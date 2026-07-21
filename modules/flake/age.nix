{
  self,
  inputs,
  ...
}:
{
  flake.agenix-rekey = inputs.agenix-rekey.configure {
    userFlake = self;
    nixosConfigurations = self.nixosConfigurations;
  };

  flake.nixosModules.age =
    { config, ... }:
    {
      imports = [
        inputs.agenix.nixosModules.default
        inputs.agenix-rekey.nixosModules.default
      ];

      age.rekey = {
        masterIdentities = [
          {
            # Host: reversed2
            identity = "/home/cncptpr/.ssh/id_ed25519";
            pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN6ZCBDzuX8ZpvCKjTLCKjaYy3H3BGkVqFiwLt+wZrQD reversed2";
          }
          {
            # Host: h0t2
            identity = "/home/cncptpr/.ssh/id_ed25519";
            pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEnYWVgKbHfCAj+f/pN3cWPdYUZwWv+t70jBkNTQfnMw h0t2";
          }
        ];
        storageMode = "local";
        # Choose a directory to store the rekeyed secrets for this host.
        # This cannot be shared with other hosts. Please refer to this path
        # from your flake's root directory and not by a direct path literal like ./secrets
        #
        #                   This is the root path, idk. why I need to do it like that.
        #                    ||
        #                    \/
        localStorageDir = ../../secrets/rekeyed/${config.networking.hostName};
      };
    };
}
