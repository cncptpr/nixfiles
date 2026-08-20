{
  flake.nixosModules.postgres = { config, ... }: {
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
}
