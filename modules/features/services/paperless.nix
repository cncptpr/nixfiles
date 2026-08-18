{
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

      age.secrets."h0t2-paperless-passwd".rekeyFile = ../../../secrets/h0t2-paperless-passwd.age;

      services.paperless = {
        enable = true;
        address = "0.0.0.0";
        port = 28981;
        configureTika = true; # OCR

        dataDir = "/mass/data/paperless";

        # Paperless can import from ${dataDir}/consume
        consumptionDirIsPublic = true;

        # Where does Posgress store it's data?
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
          PAPERLESS_URL = "https://${config.services.newt.blueprint.proxy-resources.paperless.full-domain}";
        };
      };

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
    };
}
