{
  flake.nixosModules.cncptprUser = { pkgs, ... }: {

    users.users.cncptpr = {
      isNormalUser = true;
      description = "cncptpr";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIORD/6qz7wZxaZZwF37bNQad4KZYVEzeeCOsorCRfpNs"
      ];
    };

    programs.nh = {
      enable = true;
      clean.enable = false;
      clean.extraArgs = "--keep-since 4d --keep 3";

      # sets NH_OS_FLAKE variable for you
      flake = "/home/cncptpr/nixfiles";
    };

  };
}
