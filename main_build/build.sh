#!/bin/bash

# This script creates a basic custom Linux distribution based on Ubuntu

# Set up variables
DISTRO_NAME="ShiftedOS"
DESKTOP_ENV="xfce"

# Update package repositories
apt-get update

# Install necessary packages
apt-get install -y debootstrap squashfs-tools xorriso

# Create a directory for the new distribution
mkdir -p /tmp/${DISTRO_NAME}-rootfs

# Use debootstrap to install Ubuntu base system
debootstrap --variant=minbase focal /tmp/${DISTRO_NAME}-rootfs

# Mount necessary filesystems
mount --bind /dev /tmp/${DISTRO_NAME}-rootfs/dev
mount -t proc none /tmp/${DISTRO_NAME}-rootfs/proc
mount -t sysfs none /tmp/${DISTRO_NAME}-rootfs/sys

# Chroot into the new system
chroot /tmp/${DISTRO_NAME}-rootfs /bin/bash <<EOF
# Inside chroot environment

# Install desktop environment
apt-get install -y ${DESKTOP_ENV}

# Install additional packages (customize as needed)
apt-get install -y firefox gimp 

# Customize system settings (customize as needed)
# e.g., set default wallpaper, configure desktop icons, etc.

# Set up user accounts (optional)
# e.g., create a user account for the default user

# Exit chroot environment
exit
EOF

# Unmount filesystems
umount /tmp/${DISTRO_NAME}-rootfs/dev
umount /tmp/${DISTRO_NAME}-rootfs/proc
umount /tmp/${DISTRO_NAME}-rootfs/sys

# Create a squashfs image of the filesystem
mksquashfs /tmp/${DISTRO_NAME}-rootfs ${DISTRO_NAME}.squashfs

# Create ISO image
mkdir -p iso/boot/grub
cp ${DISTRO_NAME}.squashfs iso/
cat > iso/boot/grub/grub.cfg <<EOF
set timeout=5
menuentry "${DISTRO_NAME}" {
    linux /${DISTRO_NAME}.squashfs boot=live
}
EOF
grub-mkrescue -o ${DISTRO_NAME}.iso iso

# Clean up
rm -rf /tmp/${DISTRO_NAME}-rootfs iso
