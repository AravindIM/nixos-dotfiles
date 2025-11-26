#!/usr/bin/env bash
set -x
DISK="/dev/nvme0n1"
EFI_PARTITION="p1"
ROOT_PARTITION="p2"
USERNAME="aim"
sudo umount -R /mnt
sudo lvremove -f nixos/root
sudo lvremove -f nixos/swap
sudo vgremove nixos
sudo pvremove /dev/mapper/cryptroot
sudo cryptsetup luksClose cryptroot

set -e

( 
  echo 'g';
  echo 'w';
) | sudo fdisk ${DISK}
( 
  echo 'n';
  echo '';
  echo '';
  echo '+512M';
  echo 't';
  echo 'uefi';
  echo 'w';
) | sudo fdisk ${DISK}
( 
  echo 'n';
  echo '';
  echo '';
  echo '';
  echo 'w';
) | sudo fdisk ${DISK}
( 
  echo 'p';
  echo 'q';
) | sudo fdisk ${DISK}
sudo mkfs.fat -F 32 ${DISK}${EFI_PARTITION} -n "NixOS-Boot"
sudo cryptsetup --use-random --type luks1 luksFormat -y --label="NixOS-Encrypted" ${DISK}${ROOT_PARTITION}
sudo cryptsetup luksOpen ${DISK}${ROOT_PARTITION} cryptroot
sudo pvcreate /dev/mapper/cryptroot
sudo vgcreate nixos /dev/mapper/cryptroot
sudo lvcreate --size 8G nixos --name swap
sudo lvcreate -l 100%FREE nixos --name root
sudo mkswap -f -L "NixOS-Swap" /dev/mapper/nixos-swap
sudo mkfs.btrfs -f -L "NixOS-Root" /dev/mapper/nixos-root
sudo mount -t btrfs LABEL="NixOS-Root" /mnt
sudo btrfs subvolume create /mnt/nix
sudo btrfs subvolume create /mnt/boot
sudo btrfs subvolume create /mnt/persist
sudo btrfs subvolume create /mnt/snapshots
sudo umount -R /mnt
sudo mount -t tmpfs -osize=4G,mode=755 tmpfs /mnt
sudo mkdir /mnt/home
sudo mount -t tmpfs -osize=4G,mode=777,x-mount.mkdir tmpfs /mnt/home/aim
sudo mount -t btrfs -o defaults,x-mount.mkdir,compress=zstd,ssd,noatime,nodiratime,discard=async,space_cache=v2,commit=120,subvol=nix LABEL="NixOS-Root" /mnt/nix
sudo mount -t btrfs -o defaults,x-mount.mkdir,compress=zstd,ssd,noatime,nodiratime,discard=async,space_cache=v2,commit=120,subvol=boot LABEL="NixOS-Root" /mnt/boot
sudo mount -t btrfs -o defaults,x-mount.mkdir,compress=zstd,ssd,noatime,nodiratime,discard=async,space_cache=v2,commit=120,subvol=persist LABEL="NixOS-Root" /mnt/persist
sudo mount -t btrfs -o defaults,x-mount.mkdir,compress=zstd,ssd,noatime,nodiratime,discard=async,space_cache=v2,commit=120,subvol=snapshots LABEL="NixOS-Root" /mnt/.snapshots
sudo mkdir /mnt/boot/efi
sudo mount LABEL="NixOS-Boot" /mnt/boot/efi
sudo mkdir -p /mnt/persist/home
sudo chmod 777 /mnt/persist/home
sudo mkdir -p /mnt/persist/passwords
read -srp "Password for root: " ROOTPW
echo
printf "%s" "${ROOTPW}" | mkpasswd -m SHA-512 -s | sudo tee /mnt/persist/passwords/root
read -srp "Password for ${USERNAME}: " USERPW
echo
printf "%s" "${USERPW}" | mkpasswd -m SHA-512 -s | sudo tee /mnt/persist/passwords/${USERNAME}
sudo chmod 600 /mnt/persist/passwords/${USERNAME}
UUID=$(blkid -s UUID -o value ${DISK}${ROOT_PARTITION})
sed -i '/cryptroot[[:space:]]*=[[:space:]]*{/,/}/ s|/dev/disk/by-uuid/[^"]*|/dev/disk/by-uuid/'"$UUID"'|' hosts/thinkpad/hardware-configuration.nix
sudo nixos-install --flake .#thinkpad
