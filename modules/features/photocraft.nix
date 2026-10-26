{ inputs, ... }: {
  flake.nixosModules.photocraft = { pkgs, ... }: {
    environment.systemPackages = [
      inputs.photocraft.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
