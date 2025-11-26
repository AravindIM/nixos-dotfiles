{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    nerd-fonts.departure-mono
  ];

  gtk = {
    enable = true;

    theme = {
      name = "gruvbox-dark";
      package = pkgs.gruvbox-dark-gtk;
    };

    iconTheme = {
      name = "oomox-gruvbox-dark";
      package = pkgs.gruvbox-dark-icons-gtk;
    };

    font = {
      name = "Departure Mono NerdFont 11";
    };
  };

  # Ensure GTK 4 apps (like gnome-text-editor, nautilus) use the same theme
  xdg.configFile."gtk-4.0/gtk.css".source =
    "${pkgs.gruvbox-dark-gtk}/share/themes/gruvbox-dark/gtk-4.0/gtk.css";
  xdg.configFile."gtk-4.0/assets".source =
    "${pkgs.gruvbox-dark-gtk}/share/themes/gruvbox-dark/gtk-4.0/assets";
}
