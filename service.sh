#!/system/bin/sh

MODDIR=${0%/*}
ROOTFS="$MODDIR/rootfs"
BUSYBOX="/data/adb/ksu/bin/busybox"
export PATH=/data/adb/ksu/bin:$PATH

if [ ! -d "$ROOTFS/bin" ]; then
    mkdir -p "$ROOTFS"
    $BUSYBOX tar -xzf "$MODDIR/rootfs.tar.gz" -C "$ROOTFS"
fi

sleep 20

nsenter --mount=/proc/1/ns/mnt -- sh -c "

mkdir -p $ROOTFS/dev $ROOTFS/dev/pts $ROOTFS/proc \
         $ROOTFS/sys $ROOTFS/dev/shm \
         $ROOTFS/system $ROOTFS/vendor \
         $ROOTFS/home $ROOTFS/apex

mount -o bind /dev $ROOTFS/dev
mount -o bind /proc $ROOTFS/proc
mount -o bind /sys $ROOTFS/sys
mount -o bind /vendor $ROOTFS/vendor
mount -o bind /system $ROOTFS/system
mount -o bind /apex $ROOTFS/apex
mount -t devpts devpts $ROOTFS/dev/pts
mount -t tmpfs -o size=128M tmpfs $ROOTFS/dev/shm
mount -o bind /sdcard/home $ROOTFS/home

echo 'nameserver 1.1.1.1' > $ROOTFS/etc/resolv.conf
echo 'nameserver 1.0.0.1' >> $ROOTFS/etc/resolv.conf

if [ ! -f $ROOTFS/usr/sbin/sshd ]; then
  chroot $ROOTFS /bin/sh -c '
    export PATH=/usr/sbin:/usr/bin:/sbin:/bin
    apk update
    apk add openssh nano
    ssh-keygen -A
  '
fi

chroot $ROOTFS /usr/sbin/sshd -p 8022

"

exit 0
