#!/usr/bin/env bash
set -xe
. build-maas-tarball.sh
maas admin boot-resources create name=custom/nixos-tarball title="NixOS Tarball" architecture=amd64/generic content@=${tarball}
