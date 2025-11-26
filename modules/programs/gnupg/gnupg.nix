{ config, lib, pkgs, ... }:

{
  services.gpg-agent = {
    enable = true;
    # enableSshSupport = true;
    pinentry.package = pkgs.pinentry-gnome3;
  };
  home.packages = with pkgs; [
    gnupg
  ];
}

