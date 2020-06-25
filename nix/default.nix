# This returns our pinned version of nixpkgs.
#
# The pinning of sources is handled by the niv tool
# (https://github.com/nmattia/niv). This tools updates ./sources.json which
# defines the exact version of sources like nixpkgs and the maas_centos_image
# and associates them with their hash.
#
# This file also installs an overlay that brings the sources defined by niv into
# scope. So when importing this file you can directly reference sources like:
#
#   let pkgs = import ./. {}; in pkgs.sources.maas_centos_image
#
{ system ? builtins.currentSystem }:
let
  sourcesnix = builtins.fetchurl {
    url = https://raw.githubusercontent.com/nmattia/niv/506b896788d9705899592a303de95d8819504c55/nix/sources.nix;
    sha256 = "007bgq4zy1mjnnkbmaaxvvn4kgpla9wkm0d3lfrz3y1pa3wp9ha1";
  };

  sources = import sourcesnix { sourcesFile = ./sources.json; };
in
import sources.nixpkgs {
  inherit system;
  overlays = [
    (self: super: { inherit sources; })
  ];
}
