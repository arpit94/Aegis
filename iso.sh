#!/bin/sh
set -e
. ./build.sh

mkdir -p isodir
mkdir -p isodir/boot
mkdir -p isodir/boot/grub

cp sysroot/boot/aegis.kernel isodir/boot/aegis.kernel
cat > isodir/boot/grub/grub.cfg << EOF
menuentry "Aegis" {
	multiboot /boot/aegis.kernel
}
EOF
grub-mkrescue -o aegis.iso isodir
