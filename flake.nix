{
  description = "EmergentMind's Nix-Config Starter";
  outputs =
    {
      self,
      nixpkgs,
      # nix-darwin,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      #
      # ========= Architectures =========
      #
      # NOTE(starter): Comment or uncomment architectures below as required by your hosts.
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        #"aarch64-darwin"
      ];

      # ========== Extend lib with lib.custom ==========
      # NOTE: This approach allows lib.custom to propagate into hm
      # see: https://github.com/nix-community/home-manager/pull/3454
      lib = nixpkgs.lib.extend (self: super: { custom = import ./lib { inherit (nixpkgs) lib; }; });

    in
    {
      #
      # ========= Overlays =========
      #
      # Custom modifications/overrides to upstream packages
      overlays = import ./overlays { inherit inputs; };

      #
      # ========= Host Configurations =========
      #
      # Building configurations is available through `just rebuild` or `nixos-rebuild --flake .#hostname`
      nixosConfigurations = builtins.listToAttrs (
        map (host: {
          name = host;
          value = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs outputs lib;
              isDarwin = false;
            };
            modules = [ ./hosts/nixos/${host} ];
          };
        }) (builtins.attrNames (builtins.readDir ./hosts/nixos))
      );

      # darwinConfigurations = builtins.listToAttrs (
      #   map (host: {
      #     name = host;
      #     value = nix-darwin.lib.darwinSystem {
      #       specialArgs = {
      #         inherit inputs outputs lib;
      #         isDarwin = true;
      #       };
      #       modules = [ ./hosts/darwin/${host} ];
      #     };
      #   }) (builtins.attrNames (builtins.readDir ./hosts/darwin))
      # );

      #
      # ========= Packages =========
      #
      # Expose custom packages

      /*
        NOTE: This is only for exposing packages exterally; ie, `nix build .#packages.x86_64-linux.cd-gitroot`
        For internal use, these packages are added through the default overlay in `overlays/default.nix`
      */

      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        nixpkgs.lib.packagesFromDirectoryRecursive {
          callPackage = nixpkgs.lib.callPackageWith pkgs;
          directory = ./pkgs/common;
        }
      );

      #
      # ========= Formatting =========
      #
      # Nix formatter available through 'nix fmt' https://github.com/NixOS/nixfmt
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
      # Pre-commit checks
      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./checks.nix { inherit inputs system pkgs; }
      );

      #
      # ========= DevShell =========
      #
      # Custom shell for bootstrapping on new hosts, modifying nix-config, and secrets management
      devShells = forAllSystems (
        system:
        import ./shell.nix {
          pkgs = nixpkgs.legacyPackages.${system};
          checks = self.checks.${system};
        }
      );
    };

  inputs = {
    #
    # ========= Official NixOS, Nix-Darwin, and HM Package Sources =========
    #
    # NOTE(starter): As with typical flake-based configs, you'll need to update the nixOS, hm,
    # and darwin version numbers below when new releases are available.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    # The next two inputs are for pinning nixpkgs to stable vs unstable regardless of what the above is set to.
    # This is particularly useful when an upcoming stable release is in beta because you can effectively
    # keep 'nixpkgs-stable' set to stable for critical packages while setting 'nixpkgs' to the beta branch to
    # get a jump start on deprecation changes.
    # See also 'stable-packages' and 'unstable-packages' overlays at 'overlays/default.nix"
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    #
    # ========= Utilities =========
    #
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Secrets management. See ./docs/secretsmgmt.md
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Pre-commit
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Theming
    stylix.url = "github:danth/stylix/release-25.05";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";

    #
    # ========= Programs =========
    #
    nvim = {
      # inputs.nixpkgs.follows = "nixpkgs-unstable";
      # url = "github:nix-community/neovim-nightly-overlay";
      url = "github:kbredemeier/neovim";
    };

    #
    # ========= Personal Repositories =========
    #
    # Private secrets repo.  See ./docs/secretsmgmt.md
    # Authenticates via ssh and use shallow clone
    # FIXME(starter): The url below points to the 'simple' branch of the public, nix-secrets-reference repository which is inherently INSECURE!
    # Replace the url with your personal, private nix-secrets repo.
    nix-secrets = {
      url = "git+ssh://git@github.com/kbredemeier/nix-secrets.git?shallow=1";
      inputs = { };
    };
    nix-assets = {
      url = "git+ssh://git@github.com/kbredemeier/nix-assets.git";
    };
  };
}
