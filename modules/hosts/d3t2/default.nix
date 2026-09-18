{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.d3t2 = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.d3t2Configuration ];
  };
}
