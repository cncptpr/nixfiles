{ self, ... }:
{
  flake.nixosModules.fish =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      programs.fish = {
        enable = true;
        shellInit = ''
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

          function fish_greeting
              ${pkgs.fastfetch}/bin/fastfetch
          end

          function yazi_picker
              set tmp_cwd (mktemp -t "yazi-cwd.XXXXXX")
              set tmp_chooser (mktemp -t "yazi-chooser.XXXXXX")
              command ${pkgs.yazi}/bin/yazi $argv --chooser-file="$tmp_chooser" --cwd-file="$tmp_cwd"
              if read -z chosen <"$tmp_chooser"; and test -d "$chosen"
                  printf "%s" "$chosen"
              else if read -z cwd <"$tmp_cwd"; and test -d "$cwd"
                  printf "%s" "$cwd"
              end
              command rm -f -- "$tmp_cwd" "$tmp_chooser"
          end

          function y
              set picked $(yazi_picker)
              if [ "$picked" != "$PWD" ];
                  builtin cd -- "$picked"
              end
          end

          function ty
              tmux-go $(yazi_picker)
          end
        '';
        shellAliases = lib.mkMerge [
          {
            gs = "git status";
            ga = "git add -A";
            gc = "git commit";
            gp = "git push";
            gd = "git diff";
            adog = "git log --all --decorate --oneline --graph";
          }
          (lib.mkIf config.virtualisation.docker.enable {
            du = "docker compose up -d";
            dua = "docker compose up";
            dd = "docker compose down";
            dr = "dd && du";
            dy = "docker compose pull && dr";
          })
        ];
      };
    };
}
