{ ... }:
{
  flake.nixosModules.memos =
    { config, ... }:
    let
      cfg = config.services.memos;
      port = 5230;
    in
    {
      services.memos = {
        enable = true;
        dataDir = "/mass/data/memos";
        settings = {
          MEMOS_MODE = "prod";
          MEMOS_ADDR = "127.0.0.1";
          MEMOS_PORT = toString port;
          MEMOS_DATA = "/mass/data/memos";
          MEMOS_DRIVER = "sqlite";
          MEMOS_INSTANCE_URL = "https://memos.cncptpr.xyz";
        };
      };

      custom.reverse-proxy.memos = {
        name = "Memos";
        port = port;
        domain = "memos.cncptpr.xyz";
        authentication = true;
      };

      ensureDirs.dirs."${cfg.dataDir}" = { inherit (cfg) user group; };
    };
}
