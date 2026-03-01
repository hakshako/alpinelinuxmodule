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

mkdir -p "$ROOTFS/dev" "$ROOTFS/dev/pts" "$ROOTFS/proc" "$ROOTFS/sys" "$ROOTFS/dev/shm"

if ! grep -q "$ROOTFS/dev" /proc/mounts; then
    $BUSYBOX mount -o bind /dev "$ROOTFS/dev"
fi

if ! grep -q "$ROOTFS/proc" /proc/mounts; then
    $BUSYBOX mount -o bind /proc "$ROOTFS/proc"
fi

if ! grep -q "$ROOTFS/sys" /proc/mounts; then
    $BUSYBOX mount -o bind /sys "$ROOTFS/sys"
fi

if ! grep -q "$ROOTFS/dev/pts" /proc/mounts; then
    $BUSYBOX mount -t devpts devpts "$ROOTFS/dev/pts"
fi

if ! grep -q "$ROOTFS/dev/shm" /proc/mounts; then
    $BUSYBOX mount -t tmpfs -o size=128M tmpfs "$ROOTFS/dev/shm"
fi

echo "nameserver 1.1.1.1" > "$ROOTFS/etc/resolv.conf"
echo "nameserver 1.0.0.1" >> "$ROOTFS/etc/resolv.conf"

if [ ! -f "$ROOTFS/usr/sbin/sshd" ]; then
    $BUSYBOX chroot "$ROOTFS" /bin/sh -c "
        export PATH=/usr/sbin:/usr/bin:/sbin:/bin
        apk update
        apk add nano
        apk add openssh
        ssh-keygen -A
    "
fi

if [ -f "$ROOTFS/usr/sbin/sshd" ]; then
    if ! $BUSYBOX chroot "$ROOTFS" pgrep sshd >/dev/null 2>&1; then
        $BUSYBOX chroot "$ROOTFS" /usr/sbin/sshd -p 8022
    fi
fi

exit 0
