# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "aero15";

    networkmanager.enable = true;

    useDHCP = false;

    interfaces = {
      "enp3s0".useDHCP = true;
      "wlp4s0".useDHCP = true;
    };

    firewall = {
      enable = true;
      package = pkgs.iptables;

      allowedTCPPortRanges = [{ from = 1714; to = 1764; }]; # KDE connect
      allowedUDPPortRanges = [{ from = 1714; to = 1764; }]; # KDE connect
      allowedTCPPorts = [ 4001 ]; # ipfs
      allowedUDPPorts = [ 4001 ]; # ipfs
    };

    nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
      externalInterface = "wlp4s0";
    };

    networkmanager.unmanaged = ["interface-name:ve-*"];
  };

  time.timeZone = "Asia/Seoul";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "kime";
    };
  };

  console = {
    useXkbConfig = true;
  };

  security.pam.enableSSHAgentAuth = true;

  security.wrappers = {
    ipfs = let
      cfg = config.services.ipfs;
    in {
      setuid = true;
      permissions = "u+rx,g+x";
      owner = cfg.user;
      group = cfg.group;
      source = "${cfg.package}/bin/ipfs";
    };
  };

  services = {
    ipfs = {
      enable = true;
    #  autoMount = true;
    };
    kmscon.enable = true;
    kmscon.hwRender = true;

    redis.servers = {
      "cryptostore".enable = true;
    };

    udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];

    xserver = {
      enable = true;

      layout = "us";

      dpi = 192;

      videoDrivers = ["nvidia"];

      libinput.enable = true;

      xkbOptions = "ctrl:swapcaps";

      desktopManager = {
        plasma5.enable = false;
        gnome.enable = true;
      };

      displayManager = {
       lightdm.enable = true;
       # gdm = {
       #   enable = true;
       #   wayland = true;
       #   nvidiaWayland = true;
       # };
      # sessionCommands = ''
      #   ${pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource modesetting NVIDIA-0
      #   ${pkgs.xorg.xrandr}/bin/xrandr --auto
      # '';
      };

      useGlamor = true;

      #imwheel = {
      #  enable = true;
      #  rules = {
      #    ".*" = ''
      #      None,      Up,   Button4, 10
      #      None,      Down, Button5, 10
      #    '';
      #  };
      #};
    };
    printing.enable = true;
    openssh.enable = true;
    tailscale.enable = true;
  };

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    noto-fonts-extra
    noto-fonts-cjk
    ubuntu_font_family
    hack-font
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      bash-prompt-suffix = \[\033[1;33m\]\n(nix develop)\$ \[\033[0m\]
      experimental-features = nix-command flakes
    '';
    trustedUsers = [ "root" "@wheel" ];
  };

  # Enable sound.
  sound.enable = true;

  hardware = {
    bluetooth.enable = true;
    enableAllFirmware = true;
    pulseaudio = {
      enable = true;
      extraModules = [pkgs.pulseaudio-modules-bt];
      package = pkgs.pulseaudioFull;
    };
    video.hidpi.enable = true;
    nvidia = {
      prime = {
        sync.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
      modesetting.enable = true;
    };
  };

  #powerManagement.powertop.enable = true;
  #powerManagement.cpuFreqGovernor = "performance";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."jhhuh" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "ipfs" ]; # Enable ‘sudo’ for the user.
  };

  users.users."guest".isNormalUser = true;

  environment.systemPackages = with pkgs; [
    nixos-option
    vimHugeX git tmux
  ];

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
    };
    #libvirtd.enable = true;
    virtualbox.host = {
      enable = false;
      enableExtensionPack = true;
    };
  };

  programs = {
    gnupg.agent.enable = true;
    ssh.startAgent = true;
    slock.enable = true;
  };

  system.stateVersion = "22.05"; # Did you read the comment?

}

