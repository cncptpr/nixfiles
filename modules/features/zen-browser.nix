{ inputs, ... }: {
  flake.nixosModules.zenBrowser =
    { pkgs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      zenBrowserPkg = inputs.zen-browser.packages.${system}.default;
    in
    {
      environment.systemPackages = [
        zenBrowserPkg
      ];
    };
}
