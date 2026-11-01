{ inputs, ... }: {
  flake.nixosModules.signalWhisper =
    { config, pkgs, ... }:

    let
      cfg = config.services.signal-whisper;
    in
    {
      imports = [ inputs.signal-whisper.nixosModules.default ];

      age.secrets."signal-whisper-account.db" = {
        rekeyFile = ../../secrets/signal-whisper-account.db.age;
        group = cfg.user;
        owner = cfg.user;
      };
      age.secrets."signal-whisper-accounts.json" = {
        rekeyFile = ../../secrets/signal-whisper-accounts.json.age;
      };
      age.secrets."signal-whisper-account".rekeyFile = ../../secrets/signal-whisper-account.age;
      age.secrets."signal-whisper-config.json".rekeyFile = ../../secrets/signal-whisper-config.json.age;

      services.signal-whisper = {
        enable = true;
        # model = "${inputs.signal-whisper.packages.${pkgs.stdenv.hostPlatform.system}.large-v3-q5_0}/large-v3-q5_0.bin";
        modelName = "large-v3-q5.0";
        language = "de";
        # notifySelf = true;
        # dataDir = "/mass/data/signal-whisper/";
        secrets = {
          accountsFile = config.age.secrets."signal-whisper-accounts.json".path;
          accountDbFile = config.age.secrets."signal-whisper-account.db".path;
          accountFile = config.age.secrets."signal-whisper-account".path;
          configFile = config.age.secrets."signal-whisper-config.json".path;
        };
      };

      # ensureDirs.dirs = {
      #   "${cfg.dataDir}" = {
      #     user = cfg.user;
      #     group = cfg.user;
      #   };
      # };
    };
}
