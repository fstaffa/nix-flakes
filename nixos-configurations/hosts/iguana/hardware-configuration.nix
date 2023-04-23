{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];

  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "rpool/system/root";
    fsType = "zfs";
  };

  fileSystems."/var/log" = {
    device = "rpool/system/var/log";
    fsType = "zfs";
  };

  fileSystems."/var/lib" = {
    device = "rpool/system/var/lib";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "rpool/local/nix";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "rpool/user/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "bpool/nixos/root";
    fsType = "zfs";
  };

  fileSystems."/boot/efis/nixos-boot" = {
    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
  };

  # from https://unix.stackexchange.com/questions/26364/how-can-i-create-a-tmpfs-as-a-regular-non-root-user
  # fileSystems."ramfs" = {
  #   fsType = "ramfs";
  #   device = "none";
  #   mountPoint = "/run/ramfs";
  #   options = [ "noauto" "user" "mode=1777" ];
  # };

  fileSystems."/tmp" = {
    fsType = "tmpfs";
    device = "tmpfs";
  };

  swapDevices = [{ device = "/dev/disk/nixos-swap"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s9.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
