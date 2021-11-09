VERSION=3.14.2
ARCH=x86_64
mkdir -p alpine_rootfs

export chroot_dir=$PWD/alpine_rootfs
cd alpine_rootfs
curl https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/$ARCH/alpine-minirootfs-$VERSION-$ARCH.tar.gz > alpine_rootfs.tar.gz
tar -xaf alpine_rootfs.tar.gz

mount -o bind /dev ${chroot_dir}/dev
mount -t proc none ${chroot_dir}/proc
mount -o bind /sys ${chroot_dir}/sys

cp -L /etc/resolv.conf ${chroot_dir}/etc/
chroot ${chroot_dir} /bin/ash -l
