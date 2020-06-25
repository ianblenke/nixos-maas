#
# jobset for nixos-maas
#

with import <nixpkgs> {};
 
let
  pkgs = import <nixpkgs> { inherit system; };

  runBuildMaasTarball = stdenv.mkDerivation rec {
    name = "nixos-maas";
  
    buildInputs = [
      pkgs.curl
      pkgs.gnutar
      pkgs.gzip
      buildMaasTarball
    ];

    phases = [ "installPhase" ]

    installPhase = '' 
      ${pkgs.curl}/bin/curl https://raw.githubusercontent.com/ianblenke/nixos-maas/master/build-maas-tarball.sh | ${pkgs.bash}/bin/bash -x
    '';
  };

in {
  maasTarball = runBuildMaasTarball;
}
