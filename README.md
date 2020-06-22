# nixos-maas

Boot NixOS on Ubuntu MaaS

This alters a Centos7 tarball to inject a doctored nixos-infect.

This requires three fully automated reboots:

1. Boot to Ubuntu as a comissioned node to extract our tarball that includes the doctored nixos-infect script
2. Boot to CentOS that starts a nixos-infect systemd service on boot that runs the doctored nixos-infect script
3. Boot to NixOS.

## Usage:

This project assumes you have a MaaS deployed region and controllers that are known functioning.

The centos-nix.sh script assumes:

1. The Centos7 image is installed and available in MaaS
2. That you have the maas CLI and are logged into the profile named "admin".

Run this script:

	./upload-centos-nixos.sh

Now go "Deploy" a MaaS machine using the new "NixOS Tarball" image.

You may run this script multiple times if you make any changes to update the image.

