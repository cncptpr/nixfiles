{ self, inputs, ... }:
{

  flake.nixosConfigurations.reversed2 = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.reversed2Configuration ];
  };
}
