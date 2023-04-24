{ pkgs, ... }:

{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efis/nixos-boot";
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.generationsDir.copyKernels = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.copyKernels = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.zfsSupport = true;
  boot.loader.grub.devices = [ "/dev/nvme0n1" ];

  boot.kernelPackages = pkgs.linuxPackages_6_1;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  security.pki.certificateFiles = [ ../../../common/certificates/ca.pem ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "cs_CZ.utf8";
    LC_IDENTIFICATION = "cs_CZ.utf8";
    LC_MEASUREMENT = "cs_CZ.utf8";
    LC_MONETARY = "cs_CZ.utf8";
    LC_NAME = "cs_CZ.utf8";
    LC_NUMERIC = "cs_CZ.utf8";
    LC_PAPER = "cs_CZ.utf8";
    LC_TELEPHONE = "cs_CZ.utf8";
    LC_TIME = "en_DK.utf8";
  };

  nixpkgs.config.allowUnfree = true;

  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  programs.zsh = { enable = true; };
}
