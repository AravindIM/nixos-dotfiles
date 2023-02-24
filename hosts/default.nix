{ lib, inputs, system, home-manager, user, nix-doom-emacs,... }:

{
  thinkpad = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user inputs nix-doom-emacs; };
    modules = [
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user nix-doom-emacs; };
        home-manager.users.${user} = {
          imports = [
            ./home.nix
            nix-doom-emacs.hmModule
          ];
          programs.doom-emacs = {
            enable = true;
            doomPrivateDir = ./doom.d;
          };
          services.emacs.enable = true;
        };
      }
    ];
  };
}
