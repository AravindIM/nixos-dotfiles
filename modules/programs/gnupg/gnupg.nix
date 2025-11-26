{ config, lib, pkgs, ... }:

{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-gnome3; # or pkgs.pinentry-qt / pkgs.pinentry-curses / pkgs.pinentry-tty
  };
  home.packages = with pkgs; [
    gnupg
  ];
}

