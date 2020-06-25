#
# jobset for nixos-maas
#

with import <nixpkgs> {};
 
let
  pkgs = import <nixpkgs> { inherit system; };

  nixosMaasTarball = pkgs.writeShellScriptBin "build-maas-tarball.sh" ''
    ${pkgs.curl}/bin/curl https://raw.githubusercontent.com/ianblenke/nixos-maas/master/build-maas-tarball.sh
  '';

  buildMaasTarball = stdenv.mkDerivation rec {
        name = "nixos-maas";
  
        buildInputs = [
          pkgs.curl
          pkgs.gnutar
          pkgs.gzip
          nixosMaas
        ];

        installPhase = '' 
          build-maas-tarball.sh
        '';
      }

    )
  );

in {
  tarball = buildMaasTarball
}
