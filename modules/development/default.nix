# Common development configuration.
{
  config,
  lib,
  pkgs,
  ...
}:

{
  
  environment.systemPackages = with pkgs; [
    # git related
    git
    delta

    # editor
    helix
    vim
  ];
}
