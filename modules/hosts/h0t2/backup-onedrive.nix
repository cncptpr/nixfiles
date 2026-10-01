{
  flake.nixosModules.h0t2BackupOnedrive = { pkgs, ... }: {

    # Onedrive Backup Upload
    systemd.timers."backup-upload-onedrive" = {
      description = "Run backup upload once a day";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        # Optional: randomize start up to 1h to avoid thundering herd
        RandomizedDelaySec = "1h";
      };
      wantedBy = [ "timers.target" ];
    };

    systemd.services."backup-upload-onedrive" = {
      description = "Run backup upload once";
      script = ''
        CONFIG_PATH=/mass/config/homelab/backrest/rclone/rclone.conf
        LOCAL_PATH=/mass/backups/backrest/h0T2-data-config/
        REMOTE_PATH=onedrive:homelab/backups/backrest/h0T2-data-config/

        ${pkgs.rclone}/bin/rclone --config "$CONFIG_PATH" sync "$LOCAL_PATH" "$REMOTE_PATH" -vv
      '';
    };

  };
}
