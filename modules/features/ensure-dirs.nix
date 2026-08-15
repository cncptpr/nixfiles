{
  flake.nixosModules.ensureDirs =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.custom.ensureDirs = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule (
            {
              config,
              lib,
              ...
            }:
            {
              options = {
                before = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  description = "Services that must start after this service";
                };
                user = lib.mkOption {
                  type = lib.types.str;
                  description = "User that should own the directories";
                };
                group = lib.mkOption {
                  type = lib.types.str;
                  description = "Group that should own the directories";
                };
                dirs = lib.mkOption {
                  type = lib.types.listOf lib.types.path;
                  description = "Directories to create and chown";
                };
              };
              config.group = lib.mkDefault config.user;
            }
          )
        );
        default = { };
        description = "Directories to create and chown before services start";
      };

      config.systemd.services = lib.mkMerge (
        lib.mapAttrsToList (name: svc: {
          ${name} = {
            before = svc.before;
            requiredBy = svc.before;
            unitConfig.DefaultDependencies = false;

            serviceConfig = {
              Type = "oneshot";
              User = "root";
              Group = "root";

              ExecStart = pkgs.writeShellScript "${name}.sh" ''
                set -euo pipefail

                user=${lib.escapeShellArg svc.user}
                group=${lib.escapeShellArg svc.group}

                ds=(${lib.concatStringsSep " " (map lib.escapeShellArg svc.dirs)})

                for d in "''${ds[@]}"; do
                  # Create if missing
                  if [ ! -d "$d" ]; then
                    mkdir -p "$d"
                  fi

                  # Only chown if ownership is not correct
                  cur_uid=$(stat -c '%u' "$d")
                  cur_gid=$(stat -c '%g' "$d")

                  want_uid=$(id -u "$user")
                  want_gid=$(id -g "$group")

                  if [ "$cur_uid" != "$want_uid" ] || [ "$cur_gid" != "$want_gid" ]; then
                    chown -R "$user":"$group" "$d"
                  fi
                done
              '';
            };
          };
        }) config.custom.ensureDirs
      );
    };
}
