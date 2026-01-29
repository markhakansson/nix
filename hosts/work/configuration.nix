# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  lib,
  pkgs,
  system,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.probe-rs-rules.nixosModules.${system}.default
  ];

  # Enable tools that require udev rules
  hardware.probe-rs.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;

  # Hardware related
  hardware.enableAllFirmware = true;

  # Network
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [
      10100
      10101
      10102
      10103
      10104
      10105
    ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "sv-latin1";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mark = {
    isNormalUser = true;
    description = "Mark";
    extraGroups = [
      "networkmanager"
      "wheel"
      "storage"
      "wireshark"
      "plugdev"
    ];
    packages = with pkgs; [ ];
  };

  users.groups = {
    plugdev = {};
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Rootless docker
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    curl
    wget
    fzf
    unzip
    jq
    nettools
    usbutils
    libnotify

    # development
    git
    delta

    # apps
    keepassxc
    zathura
    imv
    htop

    # editor
    helix
    vim
    vscode

    # lsp
    nil

    # wm (sway)
    grim
    mako
    slurp
    swaylock
    waybar
    wl-clipboard
    wofi

    # terminal related
    bat
    eza
    fd
    ripgrep
    ripgrep-all
    starship
    tmux
    zoxide

    # audio
    pavucontrol

    # productivity
    typst
    python3
    drawio
    libreoffice
    nix-output-monitor

    # work
    xchm
    # kicad
    # pulseview
    gtkwave
    mumble
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  programs.firefox.enable = true;
  programs.fish.enable = true;
  programs.starship.enable = true;
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/mark/nix";
  };
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  # Font configuration
  fonts.enableDefaultPackages = true;
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.sauce-code-pro
    font-awesome
  ];

  users.users.mark.shell = pkgs.fish;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "se";
    variant = "";
  };

  services.gnome.gnome-keyring.enable = true;

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  services.syncthing = {
    enable = true;
    group = "users";
    user = "mark";
    dataDir = "/home/mark"; # Default folder for new synced folders
    configDir = "/home/mark/.config/syncthing"; # Folder for Syncthing's settings and keys
  };

  services.openssh = {
    enable = true;
  };

  services.netbird = {
    enable = true;

    clients = {
      kiteshield = {
        port = 51820;
      };
    };
  };

  # For automounting disks
  services.udisks2.enable = true;

  # udev rules
  services.udev = {
    enable = true;
    packages = with pkgs; [ libsigrok ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true; # Show battery charge of Bluetooth devices
      };
    };
  };
}
