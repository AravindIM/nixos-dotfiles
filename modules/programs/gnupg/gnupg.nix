{ config, lib, pkgs, ... }:

{
  services.gpg-agent = {
    enable = true;
    # enableSshSupport = true;
    pinentry.package = pkgs.pinentry-rofi; # or pkgs.pinentry-qt / pkgs.pinentry-curses / pkgs.pinentry-tty
  };
  home.packages = with pkgs; [
    gnupg
  ];
}

