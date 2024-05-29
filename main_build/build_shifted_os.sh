#!/bin/bash

# This script creates a basic custom Linux distribution based on Ubuntu

# Set up variables
DISTRO_NAME="ShiftedOS"
DESKTOP_ENV="xfce4"
RELEASE="focal"

# Update package repositories
sudo apt-get update

# Install necessary packages
sudo apt-get install -y debootstrap squashfs-tools xorriso grub-pc-bin

# Create a directory for the new distribution
mkdir -p /tmp/${DISTRO_NAME}-rootfs

# Use debootstrap to install Ubuntu base system
sudo debootstrap --variant=minbase ${RELEASE} /tmp/${DISTRO_NAME}-rootfs http://archive.ubuntu.com/ubuntu/

# Mount necessary filesystems
sudo mount --bind /dev /tmp/${DISTRO_NAME}-rootfs/dev
sudo mount -t proc none /tmp/${DISTRO_NAME}-rootfs/proc
sudo mount -t sysfs none /tmp/${DISTRO_NAME}-rootfs/sys

# Chroot into the new system
sudo chroot /tmp/${DISTRO_NAME}-rootfs /bin/bash <<'EOF'
# Inside chroot environment

# Update package repositories
apt-get update

# Install desktop environment and additional packages
apt-get install -y ${DESKTOP_ENV} firefox gimp

# Customize system settings (customize as needed)
# e.g., set default wallpaper, configure desktop icons, etc.

# Clean up
apt-get clean

# Exit chroot environment
exit
EOF

# Unmount filesystems
sudo umount /tmp/${DISTRO_NAME}-rootfs/dev
sudo umount /tmp/${DISTRO_NAME}-rootfs/proc
sudo umount /tmp/${DISTRO_NAME}-rootfs/sys

# Create a squashfs image of the filesystem
sudo mksquashfs /tmp/${DISTRO_NAME}-rootfs ${DISTRO_NAME}.squashfs

# Create ISO image
mkdir -p iso/boot/grub
cp ${DISTRO_NAME}.squashfs iso/

# Create a basic grub configuration file
cat > iso/boot/grub/grub.cfg <<EOF
set timeout=5
menuentry "${DISTRO_NAME}" {
    linux /boot/vmlinuz boot=live
    initrd /boot/initrd.img
}
EOF

# Create the bootable ISO image
sudo grub-mkrescue -o ${DISTRO_NAME}.iso iso

# Clean up
sudo rm -rf /tmp/${DISTRO_NAME}-rootfs iso