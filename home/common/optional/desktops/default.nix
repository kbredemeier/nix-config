{ pkgs, ... }:
{
  imports = [
    # Packages with custom configs go here
    ./hyprland

    ########## Utilities ##########
    ./services/dunst.nix # Notification daemon
    ./waybar.nix # infobar
    ./rofi.nix # app launcher

  ];
  home.packages = [
    pkgs.galculator # gtk based calculator
    pkgs.pavucontrol # gui for pulseaudio server and volume controls
    pkgs.pulseaudio # add pulse audio to the user path
    pkgs.wl-clipboard # wayland copy and paste

  ];
}
