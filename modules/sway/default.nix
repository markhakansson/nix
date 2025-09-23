# Sway specific configuration
{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  environment.systemPackages = with pkgs; [
    grim
    mako
    slurp
    swaylock
    waybar
    wl-clipboard
    wofi
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
  ];

  services.dbus.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
    xdgOpenUsePortal = true;
  };
}
