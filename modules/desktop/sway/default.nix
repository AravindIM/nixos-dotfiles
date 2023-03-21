# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  exec = "exec sway";
in
{
  imports = [ ../../programs/waybar.nix ];
  environment = {
    loginShellInit = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        ${exec}
      fi
    '';                                   # Will automatically open Hyprland when logged into tty1
  };

  systemPackages = with pkgs; [
    fira-code
    font-awesome
    wl-clipboard
    swaylock-effects
    wlogout
    wofi
    foot
    sxiv
    wlogout
    pywal
    grim
    slurp
    swappy
    wl-clipboard
    wlr-randr
  ];

  programs = {
    sway = {
      enable = true;
      extraPackages = with pkgs; [

      ];
    };

    light.enable = true;
  };

  xdg-portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
}
