{
  config,
  pkgs,
  ...
}:
{
  #
  # ========= Programs integrated to zsh via option or alias =========
  #

  #Adding these packages here because the are tied to zsh
  home.packages = [
    pkgs.rmtrash # temporarily cache deleted files for recovery
    pkgs.fzf # fuzzy finder used by initExtra.zsh
  ];

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = import ./starship.nix { inherit config; };
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd" # replace cd with z and zi (via cdi)
    ];
  };

  #
  # ========= Actual zsh options =========
  #
  programs.zsh = {
    enable = true;

    # relative to ~
    dotDir = ".config/zsh";
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    autosuggestion.enable = true;
    history.size = 10000;
    history.share = true;

    # NOTE: zsh module will load *.plugin.zsh files by default if they are located in the src=<folder>, so
    # supply the full folder path to the plugin in src=. To find the correct path, atm you must check the
    # plugins derivation until PR XXXX (file issue) is fixed

    plugins = [
      {
        name = "you-should-use";
        src = "${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use";
      }
      # Allow zsh to be used in nix-shell
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
    ];

    oh-my-zsh = {
      enable = true;
      # Standard OMZ plugins pre-installed to $ZSH/plugins/
      # Custom OMZ plugins are added to $ZSH_CUSTOM/plugins/
      # Enabling too many plugins will slowdown shell startup
      plugins = [
        "git"
        "sudo" # press Esc twice to get the previous command prefixed with sudo https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo
      ];
      extraConfig = ''
        # Display red dots whilst waiting for completion.
        COMPLETION_WAITING_DOTS="true"
      '';
    };

    shellAliases = import ./aliases.nix { inherit config; };
  };
}
