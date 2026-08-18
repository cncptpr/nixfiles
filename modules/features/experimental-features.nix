{ ... }:
{
  flake.nixosModules.experimentalFeatures =
    { ... }:
    {
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
    };
}
