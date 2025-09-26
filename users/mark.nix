{
  config,
  lib,
  pkgs,
  ...
}:

{
  users.users.mark = {
    isNormalUser = true;
    description = "mark";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
  };

  programs.fish.enable = true;
  users.users.mark.shell = pkgs.fish;

  services.syncthing = {
    enable = true;
    group = "users";
    user = "mark";
    dataDir = "/home/mark"; # Default folder for new synced folders
    configDir = "/home/mark/.config/syncthing"; # Folder for Syncthing's settings and keys
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/mark/nix";
  };
}
