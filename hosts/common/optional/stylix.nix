{ inputs, pkgs, ... }:
{
  # host-wide styling
  #TODO(stylix): define themes per host via hostSpec

  stylix = {
    enable = true;
    autoEnable = true;
    image = "${inputs.nix-assets}/images/wallpapers/2560x1440/international_space_station.jpg";

    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    #FIXME(stylix): finalize custom colours and upstream to https://github.com/tinted-theming/schemes
    override = {
      scheme = "ascendancy";
      author = "emergentmind";
      base00 = "#282828"; # ----      background
      base01 = "#212F3D"; # ---       lighter background status bar
      base02 = "#504945"; # --        selection background
      base03 = "#928374"; # -         Comments, Invisibles, Line highlighting
      base04 = "#BDAE93"; # +         dark foreground status bar
      base05 = "#D5C7A1"; # ++        foreground, caret, delimiters, operators
      base06 = "#EBDBB2"; # +++       light foreground, rarely used
      base07 = "#fbf1c7"; # ++++      lightest foreground, rarely used
      base08 = "#C03900"; # red       vars, xml tags, markup link text, markup lists, diff deleted
      base09 = "#FE8019"; # orange    Integers, Boolean, Constants, XML Attributes, Markup Link Url
      base0A = "#FFCC1B"; # yellow    Classes, Markup Bold, Search Text Background
      base0B = "#B8BB26"; # green     Strings, Inherited Class, Markup Code, Diff Inserted
      base0C = "#8F3F71"; # cyan      Support, Regular Expressions, Escape Characters, Markup Quotes
      base0D = "#458588"; # blue      Functions, Methods, Attribute IDs, Headings
      base0E = "#FABD2F"; # purple    Keywords, Storage, Selector, Markup Italic, Diff Changed
      base0F = "#B59B4D"; # darkred   Deprecated Highlighting for Methods and Functions, Opening/Closing Embedded Language Tags
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
