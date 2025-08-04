{
  description = "My nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { nixpkgs, ... } @ inputs: {
    nixosConfigurations = {
      work = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/work/configuration.nix
          { 
            networking.hostName = "mark-workstation";
          }
        ];
      };

      laptop = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/laptop/configuration.nix
        ];
      };
    };
  };
}
