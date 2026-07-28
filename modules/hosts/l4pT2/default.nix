{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.l4pt2 = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.l4pt2Configuration ];
  };
}
