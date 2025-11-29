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

    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };

    font = {
      name = "Departure Mono NerdFont 11";
    };
  };

  home.sessionVariables = {
    GTK_THEME = "gruvbox-dark";
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
    HYPRCURSOR_THEME = "Adwaita";
    HYPRCURSOR_SIZE = "24";
  };

  # Ensure GTK 4 apps (like gnome-text-editor, nautilus) use the same theme
  xdg.configFile."gtk-4.0/gtk.css".source =
    "${pkgs.gruvbox-dark-gtk}/share/themes/gruvbox-dark/gtk-4.0/gtk.css";
  xdg.configFile."gtk-4.0/assets".source =
    "${pkgs.gruvbox-dark-gtk}/share/themes/gruvbox-dark/gtk-4.0/assets";
}
