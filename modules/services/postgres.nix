{
  flake.nixosModules.postgres = { config, ... }: {
    services.postgresql = {
      enable = true;
      dataDir = "/mass/data/postgres-shared";
      settings.port = 5432;
    };

    ensureDirs.dirs.${config.services.postgresql.dataDir} = {
      user = "postgres";
      group = "postgres";
    };
  };
}
