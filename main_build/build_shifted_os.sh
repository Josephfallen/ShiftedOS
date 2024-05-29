#!/bin/bash

# Shifted OS Build Script

# Step 1: Install necessary tools
echo "Installing necessary tools..."
sudo apt-get update
sudo apt-get install -y live-build debootstrap

# Step 2: Set up build environment
echo "Setting up build environment..."
mkdir -p ~/shifted-os
cd ~/shifted-os

# Step 3: Configure the live-build system
echo "Configuring live-build system..."
lb config \
    --distribution jammy \
    --architecture amd64 \
    --binary-images iso-hybrid \
    --debian-installer false \
    --archive-areas "main universe multiverse" \
    --bootappend-live "boot=live components"

# Step 4: Customize the distribution
echo "Customizing the distribution..."

# Adding packages (you can add or remove packages as needed)
echo "Adding packages..."
mkdir -p config/package-lists
cat <<EOF > config/package-lists/shifted-os.list.chroot
# Basic tools
sudo
vim
curl
wget
# Desktop environment (XFCE as an example)
xfce4
xfce4-goodies
# Network tools
network-manager
# Add other desired packages here
EOF

# Adding custom configurations
echo "Adding custom configurations..."
mkdir -p config/includes.chroot/etc/skel/
echo "Welcome to Shifted OS!" > config/includes.chroot/etc/skel/welcome.txt

# Customizing the bootloader
echo "Customizing the bootloader..."
mkdir -p config/bootloaders/isolinux/
cat <<EOF > config/bootloaders/isolinux/isolinux.cfg
UI menu.c32
PROMPT 0
MENU TITLE Shifted OS Boot Menu
TIMEOUT 50
DEFAULT live

LABEL live
    MENU LABEL ^Live (default)
    KERNEL /live/vmlinuz
    APPEND initrd=/live/initrd.img boot=live quiet splash

LABEL live failsafe
    MENU LABEL ^Live (failsafe)
    KERNEL /live/vmlinuz
    APPEND initrd=/live/initrd.img boot=live noapic noapm nodma nomce nolapic nomodeset nosmp vga=normal
EOF

# Step 5: Build the ISO
echo "Building the ISO..."
sudo lb build

# Final message
echo "Shifted OS ISO build process complete. The ISO file is located in the current directory."
