#NOTE(starter): Unlike the host-level host files that are structured as `nix-config/hosts/[platform]/[hostname]/default.nix`
# the corresponding home-level files are housed in each user's home-level config directory. This allows you to customize
# user-specific, home-manager configurations on a per user basis. The `home/common/optional/foo` configs, along with
# `home/common/core` allow you to import the specific home-manager configs you want for each host
{ lib, ... }:
{
  imports = (
    map lib.custom.relativeToRoot (
      [
        "home/common/core"
      ]
      ++ (map (f: "home/common/optional/${f}") [
        "browsers"
        "desktops"
        "comms"
        "media"
        "sops.nix"
      ])
    )
  );
}
