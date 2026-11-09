{ self, inputs, ... }:
{
  flake.nixosModules.dealveTui = { pkgs, ... }: {
    environment.systemPackages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.dealve-tui ];
  };

  perSystem =
    { system, ... }:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    {
      packages.dealve-tui = pkgs.rustPlatform.buildRustPackage {
        pname = "dealve-tui";
        version = "1.0.2";

        src = inputs.dealve-tui;
        cargoLock.lockFile = "${inputs.dealve-tui}/Cargo.lock";
        cargoBuildFlags = [ "-p" "dealve-tui" ];
        cargoInstallFlags = [ "-p" "dealve-tui" ];
        nativeBuildInputs = [ pkgs.pkg-config ];
        buildInputs = [ pkgs.openssl ];

        meta = with pkgs.lib; {
          description = "Delve into game deals from your terminal";
          homepage = "https://github.com/kurama/dealve-tui";
          license = with licenses; [ mit asl20 ];
          mainProgram = "dealve";
        };
      };
    };
}
