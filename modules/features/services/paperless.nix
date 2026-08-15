{ self, ... }: {
  flake.nixosModules.postgres = { config, ... }: {

    imports = with self.nixosModules; [ ensureDirs ];

    services.postgresql = {
      enable = true;
      dataDir = "/mass/data/postgres-shared";
      settings.port = 5432;
    };

    custom.ensureDirs.postgres-init-directories = {
      before = [
        "postgresql.service"
        "postgresql-setup.service"
      ];
      user = "postgres";
      dirs = [
        config.services.postgresql.dataDir
      ];
    };
  };

  flake.nixosModules.paperless =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.services.paperless;
    in
    {
      imports = with self.nixosModules; [
        postgres
      ];

      age.secrets."h0t2-paperless-passwd".rekeyFile = ../../../secrets/h0t2-paperless-passwd.age;

      services.paperless = {
        enable = true;
        address = "0.0.0.0";
        port = 28981;
        # configureTika = false; # OCR

        dataDir = "/mass/data/paperless";

        # Paperless can import from ${dataDir}/consume
        consumptionDirIsPublic = true;

        # # Where does Posgress store it's data?
        database.createLocally = true;

        # # Whether to enable a workaround for document classifier timeouts.
        # openMPThreadingWorkaround = true;

        passwordFile = config.age.secrets."h0t2-paperless-passwd".path;

        settings = {
          PAPERLESS_CONSUMER_IGNORE_PATTERN = [
            ".DS_STORE/*"
            "desktop.ini"
          ];
          PAPERLESS_OCR_LANGUAGE = "deu+eng";
          PAPERLESS_OCR_USER_ARGS = {
            optimize = 1;
            pdfa_image_compression = "lossless";
          };
          PAPERLESS_URL = "https://paperless.cncptpr.xyz";
        };
      };

      networking.firewall.allowedTCPPorts = [ config.services.paperless.port ];

      custom.ensureDirs.paperless-init-directories = {
        before = [ "paperless-scheduler.service" ];
        user = "paperless";
        dirs = [
          cfg.mediaDir
          cfg.exporter.directory
          cfg.consumptionDir
          "${cfg.dataDir}/index"
        ];
      };

      # systemd.services.paperless-init-directories = {
      #   # wantedBy = [ "multi-user.target" ];
      #   before = [ "paperless-scheduler.service" ];
      #   requiredBy = [ "paperless-scheduler.service" ];
      #   unitConfig.DefaultDependencies = false;
      #   serviceConfig = {
      #     Type = "oneshot";
      #     User = "root";
      #     Group = "root";
      #     ExecStart =
      #       let
      #         cfg = config.services.paperless;
      #         dirs = lib.filter (d: d != null && d != "") [
      #           cfg.mediaDir
      #           cfg.exporter.directory
      #           cfg.consumptionDir
      #         ];
      #         dirsList = lib.concatStringsSep " " (map (d: lib.escapeShellArg d) dirs);
      #       in
      #       pkgs.writeShellScript "paperless-init-dirs.sh" ''
      #         set -euo pipefail
      #         ds=(${dirsList})
      #         mkdir -p "''${ds[@]}"; chown -R paperless:paperless "''${ds[@]}"
      #       '';
      #   };
      # };

    };
}
