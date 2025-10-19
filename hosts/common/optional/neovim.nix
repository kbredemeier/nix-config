{
  pkgs,
  ...
}:
let
  nvim-unwrapped = pkgs.nvim.override (prev: {
    settings = prev.settings // {
      wrapRc = false;
    };
  });
in
{
  environment.systemPackages = [
    nvim-unwrapped
  ];
}
