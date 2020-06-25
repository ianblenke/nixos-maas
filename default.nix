#  Builds a tarball of a CentOS MAAS image containing our modified nixos-infect script.
{ system ? builtins.currentSystem }:
let
  pkgs = import ./nix { inherit system; };
  inherit (pkgs.sources) maas_centos_image;
in
pkgs.runCommandNoCC "nixos-maas-${maas_centos_image.version}.tar.gz" {
  inherit maas_centos_image;
  nixos_infect = ./nixos-infect;
} ''
  target=centos-amd64
  mkdir -p $target
  tar xzpf $maas_centos_image -C $target

  # Copy in the nixos-infect script
  chmod +w $target
  cp -a $nixos_infect $target/nixos-infect

  cat <<EOM > $target/etc/systemd/system/nixos-infect.service
  [Unit]
  Description=NixOS Infect
  After=network.target

  [Service]
  Type=simple
  User=root
  ExecStart=/nixos-infect
  Restart=on-abort

  [Install]
  WantedBy=multi-user.target
  EOM

  # Do a `systemctl enable nixos-infect.service` without chroot
  ln -s /etc/systemd/system/nixos-infect.service $target/etc/systemd/system/multi-user.target.wants/nixos-infect.service

  # Allow the following files to be read otherwise we can't tar them later on.
  chmod +r \
    $target/usr/bin/ssh-agent \
    $target/usr/bin/sudoreplay \
    $target/usr/bin/sudo \
    $target/usr/libexec/openssh/ssh-keysign \
    $target/etc/shadow- \
    $target/etc/shadow \
    $target/etc/gshadow- \
    $target/etc/gshadow

  tar czpf $out -C $target .
''
