{ ... }:
{
  flake.nixosModules.treefmt =
    { pkgs, ... }:
    {
      projectRootFile = "flake.nix";
      programs.nixfmt.enable = true;
    };
}
