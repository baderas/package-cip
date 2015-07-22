# package-cip
This script packages VMware Client Integration Plugin for Debian<br />

You need to edit $srcdir, $pkgdir and $bundle inside package_cip.sh before you can run ./package_cip.sh.<br />
Only tested on Debian Jessie amd64 with CIP version 5.5.0 x86_64.<br />

**Warning:** This script worked for me but is kind of raw and unpolished. Use at your own risk!

**Thx to:**<br />
ReNoM for his Archlinux AUR PKGBUILD<br />
https://aur.archlinux.org/packages/vm/vmware-vsphere-web-client-plugin/PKGBUILD

**Usage (example):**<br />
cd /tmp<br />
wget http://link/to/VMware-ClientIntegrationPlugin-X.Y.Z.ARCH.bundle <br />
git clone https://github.com/baderas/package-cip.git<br />
cd package-cip<br />
edit package_cip.sh and fix $srcdir, $pkgdir and $bundle <br />
./package_cip.sh<br />
sudo dpkg -i VMware-ClientIntegrationPlugin-5.5.0-x86_64.deb<br />
