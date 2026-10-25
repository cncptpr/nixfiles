{ self, inputs, ... }:
{
  flake.nixosModules.sping = { pkgs, ... }: {
    environment.systemPackages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.sping ];
  };

  perSystem =
    { system, ... }:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    {
      packages.sping = pkgs.rustPlatform.buildRustPackage {
        pname = "sping";
        version = "1.7.1";

        src = inputs.sping;
        cargoLock.lockFile = "${inputs.sping}/Cargo.lock";
        meta = with pkgs.lib; {
          description = "A modern, cross-platform ping with real-time diagnostics, network context, quality scoring, and multi-target monitoring.";
          homepage = "https://github.com/LambdaBytes/sping";
          license = licenses.mit;
          mainProgram = "sping";
        };
      };
    };
}
