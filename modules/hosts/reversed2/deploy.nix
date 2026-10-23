{ self, inputs, ... }:
let
  host = "reversed2";
in
{
  flake.deploy.nodes.${host} = {
    hostname = host;
    sshUser = "deploy";
    sshOpts = [ "-A" ];
    profiles.system = {
      user = "root";
      path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.${host};
    };
  };
}
