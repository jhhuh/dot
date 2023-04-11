{ config, pkgs, stateVersion, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ ];

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
      allowedTCPPorts = [ 4001 4011 80 135 137 138 139 5040 ]; # ipfs
      allowedUDPPorts = [ 4001 4011 67 68 69 ]; # ipfs
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

  #security.wrappers = {
  #  ipfs = let
  #    cfg = config.services.ipfs;
  #  in {
  #    setuid = true;
  #    permissions = "u+rx,g+x";
  #    owner = cfg.user;
  #    group = cfg.group;
  #    source = "${cfg.package}/bin/ipfs";
  #  };
  #};

  services = {
   # ipfs = {
   #   enable = true;
   #   autoMount = true;
   # };
    kmscon = {
      enable = true;
      hwRender = true;
      extraConfig = ''
        font-dpi=192
        xkb-options=ctrl:swapcaps
      '';   
      extraOptions = "--xkb-repeat-rate 20";
    };

    redis.servers = {
      "cryptostore".enable = true;
    };

    udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];

    xserver = {
      enable = true;

      autoRepeatDelay = 200;

      autoRepeatInterval = 20;

      layout = "us";

      dpi = 192;

      videoDrivers = ["intel"];

      libinput = {
        enable = true;
        touchpad.disableWhileTyping = true;
      };

      xkbOptions = "ctrl:swapcaps";

      windowManager.xmonad.enable = true;
      windowManager.xmonad.enableContribAndExtras = true;

      desktopManager = {
        plasma5.enable = false;
        gnome.enable = true;
        cde.enable = false;
      };

      displayManager = {
       gdm = {
         enable = true;
         wayland = false;
       };
       #lightdm.enable = true;
       sessionCommands = ''
         ${pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource modesetting NVIDIA-0
         ${pkgs.xorg.xrandr}/bin/xrandr --auto
         xset r rate 250 50
       '';
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

  # Enable sound.
  sound.enable = true;

  hardware = {
    bluetooth.enable = true;
    enableAllFirmware = true;
    pulseaudio = {
      enable = true;
      extraModules = [];
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
      powerManagement.enable = true;
    };
  };

  #powerManagement.powertop.enable = true;
  #powerManagement.cpuFreqGovernor = "performance";

  # Define a user account. Don't forget to set a password with ‘passwd’.

  users.users."guest".isNormalUser = true;

  environment.systemPackages = with pkgs; [
    nixos-option
    vimHugeX git tmux
  ];


  programs = {
    xwayland.enable = true;
    gnupg.agent.enable = true;
    ssh.startAgent = true;
    slock.enable = true;
  };

  system.stateVersion = stateVersion;

}

