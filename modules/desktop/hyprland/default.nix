{ config, lib, pkgs,... }:
let
  exec = "exec Hyprland";
in
{
  imports = [
  ];
  environment = {
    loginShellInit = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        ${exec}
      fi
    '';                                   # Will automatically open Hyprland when logged into tty1

    variables = {
      #WLR_NO_HARDWARE_CURSORS="1";         # Possible variables needed in vm
      #WLR_RENDERER_ALLOW_SOFTWARE="1";
      XDG_CURRENT_DESKTOP="Hyprland";
      XDG_SESSION_TYPE="wayland";
      XDG_SESSION_DESKTOP="Hyprland";
    };
    sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
      QT_QPA_PLATFORMTHEME = "gtk3";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      GDK_BACKEND = "wayland";
      WLR_NO_HARDWARE_CURSORS = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };
    systemPackages = with pkgs; [
      nerd-fonts.departure-mono
      font-awesome
      wl-clipboard
      wlogout
      sxiv
      hyprshot
      wl-clipboard
      wdisplays
      cliphist
      waypaper
      hyprpolkitagent
      hyprutils
      waypaper
      swww
      hyprcursor
      hyprland-protocols
      networkmanagerapplet
    ];
  };

  programs = {
    hyprland = {
      enable = true;
    };
  };
  programs.light.enable = true;
}
