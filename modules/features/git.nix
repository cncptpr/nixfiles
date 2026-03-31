{ ... }:
{
  flake.nixosModules.git =
    { ... }:
    {
      programs.git = {
        enable = true;
        config = {
          user.email = "concept1928@gmail.com";
          user.name = "cncptpr";
          push.autoSetupRemote = true;
          alias.adog = "log --all --decorate --oneline --graph";
        };
      };
    };
}
