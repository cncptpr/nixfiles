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
      node_modules = pkgs.callPackage "${src}/nix/node_modules.nix" (
        # The local script fileset patch changes the fixed-output input from
        # the hash published by OpenCode for v2.0.32. This is the hash for the
        # x86_64-linux host currently supported by this configuration.
        if system == "x86_64-linux" then {
          hash = "sha256-9h+QT6+lahxfQM8u1N5F6fxi4Ah3vSS9JYV52jpSfoU=";
        } else { }
      );
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
