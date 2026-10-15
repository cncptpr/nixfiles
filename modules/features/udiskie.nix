{
  flake.nixosModules.udiskie =
    { lib, pkgs, ... }:
    {
      services.udisks2.enable = true;

      environment.systemPackages = [ pkgs.udiskie ];

      systemd.user.services.udiskie = {
        description = "Removable disk automounter";
        wantedBy = [ "default.target" ];
        after = [ "dbus.service" ];
        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.udiskie} --automount";
          Restart = "on-failure";
        };
      };
    };
}
