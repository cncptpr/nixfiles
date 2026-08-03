{
  flake.nixosModules.nmProfiles = { config, lib, ... }: {
    age.secrets."nm-env".rekeyFile = ../../secrets/nm-env.age;

    networking.networkmanager.enable = lib.mkDefault true;

    networking.networkmanager.ensureProfiles = {
      # Put this file anywhere you like (often /etc or /run/secrets).
      # It should contain plain assignments like shown below.
      environmentFiles = [ config.age.secrets."nm-env".path ];

      profiles."home" = {
        connection = {
          id = "Home";
          uuid = "841d9bd9-fad6-4f73-95e8-bdbc2561d715";
          type = "wifi";
          interface-name = "wlp61s0";
          autoconnect = true;
        };

        wifi = {
          mode = "infrastructure";
          ssid = "$HOME_SSID";
        };

        wifi-security = {
          auth-alg = "open";
          key-mgmt = "wpa-psk";
          psk = "$HOME_PSK";
        };

        ipv4 = {
          method = "auto";
        };

        ipv6 = {
          addr-gen-mode = "default";
          method = "auto";
        };
      };

      profiles."sonnenefeu-gast" = {
        connection = {
          id = "Sonnenefeu Gast";
          uuid = "96f62b61-f450-4c3a-acc3-e3d903b8253a";
          type = "wifi";
          interface-name = "wlp61s0";
        };
        wifi = {
          mode = "infrastructure";
          ssid = "$SONNENEFEU_GAST_SSID";
        };
        wifi-security = {
          auth-alg = "open";
          key-mgmt = "wpa-psk";
          psk = "$SONNENEFEU_GAST_PSK";
        };
        ipv4 = {
          method = "auto";
        };
        ipv6 = {
          addr-gen-mode = "default";
          method = "auto";
        };
      };
    };
  };
}
