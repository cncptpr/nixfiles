{ inputs, ... }: {
  flake.nixosModules.nixd = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ nixd ];
    nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };
}
