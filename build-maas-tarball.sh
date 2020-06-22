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

  cd $target
  mount -t proc /proc proc/
  mount --rbind /sys sys/
  mount --rbind /dev dev/
  mount --rbind /tmp tmp/

  cat <<EOF > purpose.sh
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
  chroot . bash -xe ./purpose.sh

  umount $(mount | sort -r | grep ${target} | awk '{print $3}')
  umount $(mount | sort -r | grep ${target} | awk '{print $3}')
  cd ..
  tar czpf ${tarball} -C ${target} .
fi
