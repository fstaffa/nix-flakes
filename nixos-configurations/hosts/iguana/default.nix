{ config, lib, pkgs, ... }:

{
  imports =
    [
      ../../shared/common
      ../../shared/desktop
      ../../shared/vm-host
      ./hardware-configuration.nix
    ];

  networking.hostName = "iguana";

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  #nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

  users.users.mathematician314 = {
    isNormalUser = true;
    description = "mathematician314";
    extraGroups = [ "networkmanager" "wheel" ];
    hashedPassword = "$6$rounds=65536$52ozQfxuGrmWZoNo$P8rggZJwwVLeShjLdNciD.EYmsHJ3N2W82drhToZnmzdl7PXC9JzpRzEHbrr6v.6/m8VQl4erGxmSvJ6aZG0T/";
    packages = with pkgs; [
      firefox
    ];
  };

  system.stateVersion = "22.05";
}
