#!/bin/bash

# This script packages VMware Client Integration Plugin for Debian
# Tested with Version CIP version 5.5.0 x86_64 on Debian Jessie

# Thx to ReNoM <renom@list.ru> for his Archlinux AUR PKGBUILD
# https://aur.archlinux.org/packages/vm/vmware-vsphere-web-client-plugin/PKGBUILD

srcdir="/path/to/srcdir"
pkgdir="/path/to/pkdir"
bundle="/path/to/VMware-ClientIntegrationPlugin-5.5.0.x86_64.bundle"
majverf=5.5.0
majver=5.5
minver=1601065
bundle_arch=x86_64
larch=64

chmod +x "$bundle"
rm -rf "$srcdir"
rm -rf "$pkgdir"
$bundle -x "$srcdir"
mkdir -p "$pkgdir"

pwd="$(pwd)"

##### Ported from files/vmware-installer/.installer/2.1.0/vmware-installer.py around line 186
cd "$srcdir"
SRC="$srcdir/vmware-vmrc-$majver"
DEST="/usr/lib/vmware-vmrc/$majver"
libconf=$DEST/'libconf'
replace=('etc/pango/pangorc' 'etc/pango/pango.modules' 'etc/pango/pangox.aliases'
             'etc/gtk-2.0/gdk-pixbuf.loaders' 'etc/gtk-2.0/gtk.immodules')
templates=('@@LIBCONF_DIR@@')

for i in "${replace[@]}"; do
i="$SRC/libconf/$i"
for template in "${templates[@]}"; do
   sed -e s,"$template","$libconf",g -i "$i"
done
done
cd "$pkgdir"
mkdir -p usr/lib/vmware-cip/${majver}/
mkdir -p usr/lib/vmware-vmrc/${majver}/
mkdir -p usr/lib/mozilla/plugins
mkdir -p etc/vmware-vmrc/${majver}
echo "libdir = \"/usr/lib/vmware-vmrc/$majver\"" > etc/vmware-vmrc/${majver}/config
# install cip
cp ${srcdir}/vmware-cip-55/npVMwareClientSupportPlugin-5-5-0.so "usr/lib/vmware-cip/$majver/"
mv "$srcdir/vmware-cip-55/artwork" "usr/lib/vmware-cip/$majver/"
mv "$srcdir/vmware-cip-55/filetransfer" "usr/lib/vmware-cip/$majver/"
chmod +x "usr/lib/vmware-cip/$majver/filetransfer/fileTransfer"
mv "$srcdir/vmware-cip-55/ovftool" "usr/lib/vmware-cip/$majver/"
chmod +x "usr/lib/vmware-cip/$majver/ovftool/ovftool"
chmod +x "usr/lib/vmware-cip/$majver/ovftool/ovftool.bin"
ln -s "/usr/lib/vmware-cip/$majver/npVMwareClientSupportPlugin-5-5-0.so" "usr/lib/mozilla/plugins/npVMwareClientSupportPlugin-5-5-0.so"
# install vmrc
cp "$srcdir/vmware-vmrc-$majver/np-vmware-vmrc-$majverf-$minver-32.so" "usr/lib/vmware-vmrc/$majver/"
cp "$srcdir/vmware-vmrc-$majver/np-vmware-vmrc-$majverf-$minver-64.so" "usr/lib/vmware-vmrc/$majver/"
cp "$srcdir/vmware-vmrc-$majver/np-vmware-vmrc.so" "usr/lib/vmware-vmrc/$majver/"
cp "$srcdir/vmware-vmrc-$majver/open_source_licenses.txt" "usr/lib/vmware-vmrc/$majver/"
cp "$srcdir/vmware-vmrc-$majver/version.txt" "usr/lib/vmware-vmrc/$majver/"
cp "$srcdir/vmware-vmrc-$majver/vmware-desktop-entry-creator" "usr/lib/vmware-vmrc/$majver/"
mv "$srcdir/vmware-vmrc-$majver/bin" "usr/lib/vmware-vmrc/$majver/"
chmod -R +x "usr/lib/vmware-vmrc/$majver/bin/"
mv "$srcdir/vmware-vmrc-$majver/lib" "usr/lib/vmware-vmrc/$majver/"
mv "$srcdir/vmware-vmrc-$majver/libconf" "usr/lib/vmware-vmrc/$majver/"
mv "$srcdir/vmware-vmrc-$majver/share" "usr/lib/vmware-vmrc/$majver/"
mv "$srcdir/vmware-vmrc-$majver/xkeymap" "usr/lib/vmware-vmrc/$majver/"
ln -s /usr/lib/vmware-vmrc/${majver}/np-vmware-vmrc-${majverf}-$minver-${larch}.so usr/lib/mozilla/plugins/np-vmware-vmrc-${majverf}-1601065-${larch}.so
ln -s /usr/lib/vmware-vmrc/${majver}/bin/appLoader usr/lib/vmware-vmrc/${majver}/bin/vmware-deviceMgr
ln -s /usr/lib/vmware-vmrc/${majver}/bin/appLoader usr/lib/vmware-vmrc/${majver}/bin/vmware-vmrc
ln -s /usr/lib/vmware-vmrc/${majver}/bin/appLoader usr/lib/vmware-vmrc/${majver}/bin/vmware-vmrc-daemon
ln -s /usr/lib/vmware-vmrc/${majver}/bin/vmware-deviceMgr usr/lib/vmware-vmrc/${majver}/vmware-deviceMgr
ln -s /usr/lib/vmware-vmrc/${majver}/bin/vmware-vmrc usr/lib/vmware-vmrc/${majver}/vmware-vmrc
ln -s /usr/lib/vmware-vmrc/${majver}/bin/vmware-vmrc-daemon usr/lib/vmware-vmrc/${majver}/vmware-vmrc-daemon

mkdir "$pkgdir/DEBIAN"
echo "Package: vmware-vsphere-web-client-plugin" >> "$pkgdir/DEBIAN/control"
echo "Section: devel" >> "$pkgdir/DEBIAN/control"
echo "Version: $majverf" >> "$pkgdir/DEBIAN/control"
echo "Maintainer: Andreas Bader <Development@Geekparadise.de>" >> "$pkgdir/DEBIAN/control"
echo "Architecture: amd64" >> "$pkgdir/DEBIAN/control"
echo "Depends: " >> "$pkgdir/DEBIAN/control"
echo "Suggests: " >> "$pkgdir/DEBIAN/control"
echo "Conflicts: " >> "$pkgdir/DEBIAN/control"
echo "Description: The VMware vSphere Web Client Plugin" >> "$pkgdir/DEBIAN/control"
cd "$pwd"
dpkg-deb -b "$pkgdir" "VMware-ClientIntegrationPlugin-${majverf}-${bundle_arch}.deb"
rm -rf "$srcdir"
rm -rf "$pkgdir"
exit 0