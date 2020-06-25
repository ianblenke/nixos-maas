#
# jobset for nixos-maas
#

with import <nixpkgs> {};
 
let
  pkgs = import <nixpkgs> { inherit system; };

  buildMaasTarball = pkgs.writeShellScriptBin "build-maas-tarball.sh" ''
    ${pkgs.curl}/bin/curl https://raw.githubusercontent.com/ianblenke/nixos-maas/master/build-maas-tarball.sh | ${pkgs.bash}/bin/bash -x
  '';

  runBuildMaasTarball = stdenv.mkDerivation rec {
    name = "nixos-maas";
  
    buildInputs = [
      pkgs.curl
      pkgs.gnutar
      pkgs.gzip
      buildMaasTarball
    ];
  };

in {
  maasTarball = runBuildMaasTarball;
}
