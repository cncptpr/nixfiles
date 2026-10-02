{
  flake.nixosModules.deployUser = {

    users.users.deploy = {
      isNormalUser = true;
      description = "System deploy user";
      uid = 2000;
      extraGroups = [
        "wheel"
        "sudo"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIORD/6qz7wZxaZZwF37bNQad4KZYVEzeeCOsorCRfpNs"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAemPZp+ExfvOvH4V3b+YY2St2ov0+DtsKZ48YsAZnkZ"
      ];
    };

    # Enable 'sudo' with SSH key
    security.pam = {
      services.sudo.sshAgentAuth = true;
      sshAgentAuth.enable = true;
    };

    nix.settings.trusted-users = [ "deploy" ];

  };
}
