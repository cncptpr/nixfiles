{ inputs, ... }: {
  flake.nixosModules.signalWhisper =
    { config, ... }:
    let
      cfg = config.services.signal-whisper;
    in
    {
      imports = [ inputs.signal-whisper.nixosModules.default ];

      age.secrets."signal-whisper-account.db" = {
        rekeyFile = ../../secrets/signal-whisper-account.db.age;
        group = cfg.group;
        owner = cfg.user;
      };
      age.secrets."signal-whisper-accounts.json" = {
        rekeyFile = ../../secrets/signal-whisper-accounts.json.age;
      };
      age.secrets."signal-whisper-account".rekeyFile = ../../secrets/signal-whisper-account.age;
      age.secrets."signal-whisper-config.json".rekeyFile = ../../secrets/signal-whisper-config.json.age;

      services.signal-whisper = {
        enable = true;
        modelName = "large-v3-q5.0";
        language = "de";
        transcribeOwnMessages = true;
        secrets = {
          accountsFile = config.age.secrets."signal-whisper-accounts.json".path;
          accountDbFile = config.age.secrets."signal-whisper-account.db".path;
          accountFile = config.age.secrets."signal-whisper-account".path;
          configFile = config.age.secrets."signal-whisper-config.json".path;
        };
      };
    };
}
