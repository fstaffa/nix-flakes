{ config, lib, pkgs, pkgs-unstable, ... }:

let
  stable-packages = with pkgs; [
    # Applications
    brave
    burpsuite
    firefox
    slack
    vlc

    # Development
    jetbrains.datagrip
    jetbrains.webstorm
    jetbrains.rider
  ];
  unstable-packages = with pkgs-unstable; [ keymapp ];
in {
  home.packages = stable-packages ++ unstable-packages;
  home.sessionVariables = { NIXOS_OZONE_WL = "1"; };

  services.syncthing.enable = true;
  services.opensnitch-ui.enable = true;
}
