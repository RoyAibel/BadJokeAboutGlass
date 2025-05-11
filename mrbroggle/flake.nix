{
  description = "A Nix system for someone who drinks water";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };
  outputs =
    {
      nixpkgs,
    }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations."Water Drinker" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          {
            programs.zsh = {
              enable = true;
              shellInit = "while true; do echo 'Drinking water'; done;";
            };
            users.defaultUserShell = nixpkgs.zsh;
          }
        ];
      };
    };
}
