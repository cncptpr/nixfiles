{ ... }:
{
  flake.nixosModules.fish =
    { ... }:
    {
      programs.fish = {
        enable = true;
        shellAliases = {
          gs = "git status";
          ga = "git add -A";
          gc = "git commit";
          gp = "git push";
          gd = "git diff";
          adog = "git log --all --decorate --oneline --graph";
        };
      };
    };
}
