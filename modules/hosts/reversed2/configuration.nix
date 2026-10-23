{
  self,
  ...
}:
{
  flake.nixosModules.reversed2Configuration =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      host = "reversed2";
      number_wg_clients = 3;
      tailscale_secret = "tailscale-auth-key-reversed2";
    in
    {

      imports = with self.nixosModules; [
        #Nixos
        base
        reversed2Hardware
        staticNetworking
        age
        deployUser
        openssh

      ];

      # from /etc/ssh/ssh_host_ed25519_key.pub
      age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5SUtLQfW/1IE6TO9nkekxaHYM3D72qWjMVPJMIS5Yv root@nixos";

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      staticNetworking = {
        address = "185.119.16.106";
        prefixLength = 32;
        gateway = "37.114.36.0";
        interface = "ens18";
      };

      networking.hostName = host;

      virtualisation.docker.enable = true;

      services.tailscale = {
        enable = true;
        useRoutingFeatures = "server";
        authKeyFile = config.age.secrets.${tailscale_secret}.path;
      };

      # BEGIN === Wireguard ===

      age.secrets = {
        ${tailscale_secret}.rekeyFile = ../../../secrets/${tailscale_secret}.age;
        "wg-${host}-server".rekeyFile = ../../../secrets/wg-${host}-server.age;
      }
      // lib.mergeAttrsList (
        map (i: {
          "wg-${host}-client-${toString i}".rekeyFile = ../../../secrets/wg-${host}-client-${toString i}.age;
        }) (lib.range 1 number_wg_clients)
      );

      networking.wg-quick.interfaces.wg0.configFile = config.age.secrets."wg-${host}-server".path;

      environment.systemPackages = with pkgs; [ iptables ];

      # IP Forwarding.
      # Required to allow wireguard clients to access the internet.
      # Standard wg-quick iptable setup is also needed.
      boot.kernel.sysctl = {
        "net.ipv4.ip_forward" = 1;
      };

      # END === Wireguard ===

      system.stateVersion = "25.11";
    };
}
