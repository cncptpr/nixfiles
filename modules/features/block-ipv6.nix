{
  flake.nixosModules.blockIPv6 = {
      networking.nftables.enable = true;
      networking.nftables.ruleset = ''
        table ip6 filter {
          chain input {
            type filter hook input priority 0;
            policy drop;
          }
        }
      '';
  };
}
