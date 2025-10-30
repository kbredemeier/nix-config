{ inputs, pkgs, ... }:
{
  # host-wide styling
  #TODO(stylix): define themes per host via hostSpec

  stylix = {
    enable = true;
    autoEnable = true;
    image = "${inputs.nix-assets}/images/wallpapers/2560x1440/international_space_station.jpg";

    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    override = {
      base0E = "#f2cdcd"; # flamingo accent color
    };
    opacity = {
      applications = 1.0;
      terminal = 1.0;
      desktop = 1.0;
      popups = 0.8;
    };
    polarity = "dark";

    #cursor = {
    #        package = pkgs.foo;
    #        name = "";
    #      };

    fonts = rec {
      monospace = {
        package = pkgs.unstable.nerd-fonts.fira-mono;
        name = "FiraMono Nerd Font Mono"; # Like FiraCode but without ligatures
      };
      sansSerif = monospace;
      serif = monospace;
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        #FiraCode/FiraMono is great but hard to read at 12 on 4k
        terminal = 14;
        desktop = 14;
        popups = 12;
      };
    };
    # program specific exclusions
    #targets.foo = {
    #  enable = true;
    #  property = bar;
    #};

  };
}
