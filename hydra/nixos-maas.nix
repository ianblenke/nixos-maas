#
# jobset for nixos-maas
#

with import <nixpkgs> {};

let
  nixosMaas = pkgs.writeShellScriptBin "nixos-maas" ''
    ${pkgs.curl}/bin/curl https://raw.githubusercontent.com/ianblenke/nixos-maas/master/build-maas-tarball.sh | ${pkgs.bash}/bin/bash -x
  '';
in
stdenv.mkDerivation {
  name = "nixos-maas";

  buildInputs = [ nixosMaas ];
}
