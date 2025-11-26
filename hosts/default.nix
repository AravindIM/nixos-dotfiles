{ lib, inputs, system, impermanence, home-manager, user, hyprland, zen-browser, ... }:

{
  thinkpad = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user inputs hyprland impermanence zen-browser;};
    modules = [
      impermanence.nixosModules.impermanence {
        environment.persistence."/persist" = {
           directories = [
             "/var/log"
             "/var/lib/bluetooth"
             "/var/lib/nixos"
             "/var/lib/systemd/coredump"
             "/var/lib/systemd/timers"
             "/etc/NetworkManager/system-connections"
           ];
           files = [
             "/etc/machine-id"
             {
               file = "/etc/nix/id_rsa";
               parentDirectory = {
                 mode = "u=rwx,g=,o=";
               };
             }
           ];
        };
      }

      ./thinkpad/configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user hyprland;};
        home-manager.users.${user} = {
          imports = [
            impermanence.homeManagerModules.impermanence
            ./thinkpad/home.nix
            ../modules/desktop/hyprland/home.nix
            ../modules/theme/gruvbox.nix
            ../modules/programs/gnupg/gnupg.nix
          ] ++ (import ../modules/shell)
          ++ (import ../modules/editor);

          home.persistence."/persist/home/${user}" = {
            allowOther = true;
            removePrefixDirectory = false;
            directories = [
              ".gnupg"
              ".ssh"
              ".zen"
              ".config/waypaper/config.ini"
              "Documents"
              "Downloads"
              "Music"
              "Pictures"
              "Projects"
              "Videos"
            ];
            files = [
              ".gitconfig"
            ];
          };
        };
      }
      hyprland.nixosModules.default
    ] ++ [(import ../modules/desktop/hyprland)];
  };
}
