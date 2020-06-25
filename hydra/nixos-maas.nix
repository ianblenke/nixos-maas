#
# jobset for nixos-maas
#

with import <nixpkgs> {};
 
let
  pkgs = import <nixpkgs> { inherit system; };

  nixosMaas = pkgs.writeShellScriptBin "build-maas-tarball.sh" ''
    ${pkgs.curl}/bin/curl https://raw.githubusercontent.com/ianblenke/nixos-maas/master/build-maas-tarball.sh
  '';

  jobs = (
    mapTestOn (

      stdenv.mkDerivation rec {
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

in jobs
