{ ... }:
{
  flake.nixosModules.fish =
    { config, lib, ... }:
    {
      programs.fish = {
        enable = true;
        shellInit = "
          function tmux-go
            set -l target (realpath $argv[1])
            set -l sess (basename $target)

            if set -q TMUX
                tmux switch-client -t $sess
                if test $status -ne 0
                    tmux new-session -d -s $sess -c $target
                    tmux switch-client -t $sess
                end
            else
                tmux new-session -A -s $sess -c $target
            end
        end
        ";
        shellAliases = {
          gs = "git status";
          ga = "git add -A";
          gc = "git commit";
          gp = "git push";
          gd = "git diff";
          adog = "git log --all --decorate --oneline --graph";
        } // lib.mkIf config.virtualisation.docker.enable {
          du = "docker compose up -d";
          dua = "docker compose up";
          dd = "docker compose down";
          dr = "dd && du";
          dy = "docker compose pull && dr";
        };
      };
    };
}
