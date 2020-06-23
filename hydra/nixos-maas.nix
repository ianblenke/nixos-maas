#
# jobset for nixos-maas
#

with import <nixpkgs> {};

let
  # The ${...} is for string interpolation
  # The '' quotes are used for multi-line strings
  simplePackage = pkgs.writeShellScriptBin "nix-maas" ''
    ${pkgs.curl}/bin/curl https://raw.githubusercontent.com/ianblenke/nixos-maas/master/build-maas-tarball.sh | ${pkgs.bash}/bin/bash -x
  '';
in
stdenv.mkDerivation rec {
  name = "nixos-maas";

  buildInputs = [ simplePackage pkgs.curl pkgs.bash ];
}
