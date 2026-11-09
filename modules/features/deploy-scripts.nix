{ self, inputs, ... }:
let
  lib = inputs.nixpkgs.lib;
  deployNodes = self.deploy.nodes or { };
in
{
  flake.nixosModules.deployScripts =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.deploy-rs
      ]
      ++ (
        deployNodes
        |> lib.mapAttrsToList (
          name: _:
          pkgs.writeShellScriptBin "deploy-${name}" ''
            set -euo pipefail
            git add --intent-to-add -A
            deploy -sk --targets "/home/cncptpr/nixfiles#${name}" "$@" -- --log-format internal-json -v |& nom --json
          ''
        )
      );
    };
}
