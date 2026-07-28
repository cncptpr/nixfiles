{ self, inputs, ... }:
{
  flake.deploy.nodes.h0t2 = {
    hostname = "h0t2";
    profiles.system = {
      path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.h0t2;
      sshUser = "cncptpr";
      user = "root";
      interactiveSudo = true;
      remoteBuild = true;
    };
  };
}
