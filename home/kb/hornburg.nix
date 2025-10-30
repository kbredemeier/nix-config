# NOTE(starter): Unlike the host-level host files that are structured as `nix-config/hosts/[platform]/[hostname]/default.nix`
# the corresponding home-level files are housed in each user's home-level config directory. This allows you to customize
# user-specific, home-manager configurations on a per user basis. The `home/common/optional/foo` configs, along with
# `home/common/core` allow you to import the specific home-manager configs you want for each host
{ lib, ... }:
{
  imports = (
    map lib.custom.relativeToRoot (
      [
        #
        # ========== Required Configs ==========
        #
        #FIXME: after fixing user/home values in HM
        "home/common/core"
        "home/common/core/nixos.nix"

        "home/kb/common/nixos.nix"
      ]
      ++
        #
        # ========== Host-specific Optional Configs ==========
        #
        (map (f: "home/common/optional/${f}") [
          "browsers"
          "comms"
          "desktops" # default is hyprland
          "media"
          "tools"
          "sops.nix"
          "xdg.nix"
        ])
    )
  );

  #
  # ========== Host-specific Monitor Spec ==========
  #
  # This uses the nix-config/modules/home/montiors.nix module which defaults to enabled.
  # Your nix-config/home-manger/<user>/common/optional/desktops/foo.nix WM config should parse and apply these values to it's monitor settings
  # If on hyprland, use `hyprctl monitors` to get monitor info.
  # https://wiki.hyprland.org/Configuring/Monitors/
  #    ------
  # | Internal |
  # | Display  |
  #    ------
  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      refreshRate = 60;
      primary = true;
      #vrr = 1;
    }
  ];
}
