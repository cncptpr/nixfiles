{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.h0t2 = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.h0t2Configuration ];
  };
}

