#!/usr/bin/env bash -ex
target=centos-amd64.$(date +%Y%m%d%H%M%S)
tarball=${target}.tar.gz
if [ ! -d $target ]; then
  mkdir -p $target
  if [ ! -f root-tgz ]; then
    curl -Lo root-tgz https://images.maas.io/ephemeral-v3/daily/centos70/amd64/20190701_01/root-tgz
  fi
  tar xzpf root-tgz -C $target

  # Copy in the nixos-infect script
  cp -a nixos-infect $target/nixos-infect

  cat <<EOF > $target/purpose.sh
#!/bin/bash -xe
cat <<EOM > /etc/systemd/system/nixos-infect.service
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
systemctl enable nixos-infect.service
EOF
  chroot $target bash -xe ./purpose.sh

  tar czpf ${tarball} -C ${target} .
fi
