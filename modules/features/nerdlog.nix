{ self, inputs, ... }:
{
  flake.nixosModules.nerdlog = { pkgs, ... }: {
    environment.systemPackages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.nerdlog ];
  };

  perSystem =
    { system, ... }:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    {
      packages.nerdlog = pkgs.buildGoModule {
        pname = "nerdlog";
        version = "1.13.0";

        src = inputs.nerdlog;
        vendorHash = "sha256-HZp35LVba3md/yJlaImpvkpbUOfe8bN9U5gdzOeLS3c=";
        subPackages = [ "cmd/nerdlog" ];
        doCheck = false;

        meta = with pkgs.lib; {
          description = "Fast, remote-first, multi-host TUI log viewer";
          homepage = "https://github.com/dimonomid/nerdlog";
          license = licenses.bsd2;
          mainProgram = "nerdlog";
        };
      };
    };
}
