{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system: rec {
      nixosConfigurations.water = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs.inputs = inputs;
        modules = [
          (
            { pkgs, ... }:
            {
              users.groups.admin = { };
              users.users = {
                water = {
                  isNormalUser = true;
                  extraGroups = [ "wheel" ];
                  password = "admin";
                  group = "admin";
                };
              };

              virtualisation.vmVariant = {
                virtualisation = {
                  memorySize = 2048;
                  cores = 1;
                  graphics = true;
                };
              };
              services.cage = {
                enable = true;
                user = "water";
                program = "${pkgs.alacritty}/bin/alacritty -e ${pkgs.bash}/bin/bash -c 'while true; do echo \"DRINK WATER\"; done;'";
              };

              system.stateVersion = "23.05";
            }
          )
        ];
      };
      apps = {
        default = {
          type = "app";
          program = "${nixosConfigurations.water.config.system.build.vm}/bin/run-nixos-vm";
        };
      };
    });
}
