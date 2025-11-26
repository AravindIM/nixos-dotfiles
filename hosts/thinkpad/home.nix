{ config, pkgs, ...}:
{
  home.username = "aim";
  home.homeDirectory = "/home/aim";

  home.packages = with pkgs; [
    rename
    htop
    git
    neofetch
    gcc
    zip
    unzip
    unrar
    bzip2
    bzip3
    xz
    gzip
    vlc
    zathura
    gimp
    spotify
    bluez
    mpv
  ];
  
  services.mpris-proxy.enable = true;
  services.blueman-applet.enable = true;

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.stateVersion = "22.11";
}

