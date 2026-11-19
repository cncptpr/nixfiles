{ inputs, ... }: {
  flake.nixosModules.mm = { pkgs, ... }: {
    environment.systemPackages = [ inputs.mm.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
}
