{ ... }:
{
  flake.nixosModules.mastodon =
    { ... }:
    {
      security.acme = {
        acceptTerms = true;
        defaults.email = "concept1928@gmail.com";
      };
      services.mastodon = {
        enable = true;
        localDomain = "mastodon.cncptpr.xyz";
        configureNginx = true;
        smtp.fromAddress = "concept1928@gmail.com";
        extraConfig.SINGLE_USER_MODE = "true";

        # Number of processes used by the mastodon-streaming service.
        # Recommended is the amount of your CPU cores minus one.
        streamingProcesses = 1;
      };
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];
    };
}
