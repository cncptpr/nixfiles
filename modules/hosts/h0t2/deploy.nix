{ self, inputs, ... }:
{
  flake.deploy.nodes.h0t2 = {
    hostname = "h0t2";
    sshUser = "deploy";
    sshOpts = [ "-A" ];
    remoteBuild = true;
    profiles.system = {
      user = "root";
      path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.h0t2;
    };
  };
}
