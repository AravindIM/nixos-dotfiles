{ config, pkgs, ...}:
{
  home.username = "aim";
  home.homeDirectory = "/home/aim";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    fira-code
    rename
    htop
    git
    neofetch
    gcc
    vlc
    zathura
    gimp
    xournal
    spotify
    whatsapp-for-linux
    bluez
    mpv
    fzf
    nodePackages.peerflix
    transmission-gtk
  ];

  services.mpris-proxy.enable = true;
  services.blueman-applet.enable = true;

  home.file.".config/foot" = {
    source = ./config/foot;
    recursive = true;
  };

  home.file.".config/waybar" = {
    source = ./config/waybar;
    recursive = true;
  };

  home.file.".config/wofi" = {
    source = ./config/wofi;
    recursive = true;
  };

  home.file.".config/wal" = {
    source = ./config/wal;
    recursive = true;
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      wal -Reqn
    '';
  };

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.stateVersion = "22.11";
}

