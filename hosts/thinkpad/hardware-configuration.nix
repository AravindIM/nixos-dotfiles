{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        enableCryptodisk = true;
      };
    };

    kernelPackages = pkgs.linuxPackages_latest;
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
      kernelModules = [ "dm-snapshot" "cryptd"];
      secrets = {
        "/etc/cryptkey/cryptlvm.keyfile" = /persist/etc/cryptkey/cryptlvm.keyfile;
      };
      luks.devices = {
        cryptroot = {
          device = "/dev/disk/by-uuid/56ad7a2c-fc86-4f87-9c46-20dfb3cc34c6";
          keyFile = "/etc/cryptkey/cryptlvm.keyfile";
          preLVM = true;
          allowDiscards = true;
        };
      };
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "btrfs" ];
    kernelParams = [ "cryptkey=rootfs:/etc/cryptkey/cryptlvm.keyfile" ];
  };

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [
      "size=4G"
      "mode=755"
    ];
    neededForBoot = true;
  };

  fileSystems."/home" = {
    device = "none";
    fsType = "tmpfs";
    options = [
      "size=4G"
      "mode=777"
      "x-mount.mkdir"
    ];
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NixOS-Root";
    fsType = "btrfs";
    options = [
      "defaults"
      "x-mount.mkdir"
      "compress=zstd"
      "ssd"
      "noatime"
      "nodiratime"
      "discard=async"
      "space_cache=v2"
      "commit=120"
      "subvol=boot"
    ];
    neededForBoot = true;
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/NixOS-Root";
    fsType = "btrfs";
    options = [
      "defaults"
      "x-mount.mkdir"
      "compress=zstd"
      "ssd"
      "noatime"
      "nodiratime"
      "discard=async"
      "space_cache=v2"
      "commit=120"
      "subvol=nix"
    ];
    neededForBoot = true;
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-label/NixOS-Root";
    fsType = "btrfs";
    options = [
      "defaults"
      "x-mount.mkdir"
      "compress=zstd"
      "ssd"
      "noatime"
      "nodiratime"
      "discard=async"
      "space_cache=v2"
      "commit=120"
      "subvol=persist"
    ];
    neededForBoot = true;
  };

  fileSystems."/.snapshots" = {
    device = "/dev/disk/by-label/NixOS-Root";
    fsType = "btrfs";
    options = [
      "defaults"
      "x-mount.mkdir"
      "compress=zstd"
      "ssd"
      "noatime"
      "nodiratime"
      "discard=async"
      "space_cache=v2"
      "commit=120"
      "subvol=snapshots"
    ];
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-label/NixOS-Boot";
    fsType = "vfat";
    neededForBoot = true;
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/NixOS-Swap"; 
    }
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "balanced";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
