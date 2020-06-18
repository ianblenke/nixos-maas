#!/bin/bash -x
target=centos-amd64.$(date +%Y%m%d%H%M%S)
tarball=${target}.tar.gz
if [ ! -d $target ]; then
  mkdir $target
  tar xzpf /var/lib/maas/boot-resources/current/centos/amd64/generic/centos70/daily/root-tgz -C $target

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
  maas admin boot-resources create name=custom/nixos-tarball title="NixOS Tarball" architecture=amd64/generic content@=${tarball}
fi
