{ self, inputs, ... }:
{
  perSystem =
    { system, ... }:
    let
      pkgs = inputs.nixpkgs-opencode.legacyPackages.${system};
      src = pkgs.applyPatches {
        name = "opencode-v2.0.32-patched";
        src = inputs.opencode;
        patches = [ ./opencode-v2-script.patch ];
      };
      node_modules = pkgs.callPackage "${src}/nix/node_modules.nix" { };
      opencode = pkgs.callPackage "${src}/nix/opencode.nix" {
        inherit node_modules;
      };
    in
    {
      packages.opencode = opencode;
    };

  flake.nixosModules.opencode =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.opencode
      ];
    };
}
