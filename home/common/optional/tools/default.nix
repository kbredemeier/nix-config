{ pkgs, ... }:
{
  #imports = [ ./foo.nix ];

  home.packages = builtins.attrValues {
    inherit (pkgs)
      # Device imaging
      rpi-imager

      # Productivity
      drawio
      libreoffice

      # Media production
      gimp
      inkscape
      ;

    inherit (pkgs.unstable)
      grimblast # screenshot tool
      ;
  };
}
