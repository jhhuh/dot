{ config, pkgs, lib, stateVersion, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking.hostName = "tres-cantos";
  networking.networkmanager.enable = true;

  console.font = "latarcyrheb-sun32";
  console.useXkbConfig = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "kime";
      kime.config = {
        indicator.icon_color = "White";
      };
    };
  };

  programs = {
    singularity.enable = true;
    ssh.startAgent = true;
    slock.enable = true;
  };

  environment.systemPackages = with pkgs; [
    nixos-option
    pciutils hdparm powertop htop
    acpitool
    wget git vim tmux
  ];

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      roboto-mono
      baekmuk-ttf source-han-sans-korean
      ubuntu_font_family
      #google-fonts
      #noto-fonts
      noto-fonts-cjk
      #noto-fonts-emoji
      #terminus_font_ttf
      #inconsolata
      #source-code-pro
      #ttf_bitstream_vera
      #open-dyslexic
      #source-code-pro
    ];
  };

  hardware.pulseaudio.enable = true;

  security.unprivilegedUsernsClone = true;

  services = {
    pipewire.wireplumber.enable = false;

    redis.servers = {
      "cryptostore".enable = true;
      "cryptostore".bind = "127.0.0.1";
      "cryptostore".port = 6379;
    };

    xserver = {
      enable = true;
      xkbOptions = "ctrl:swapcaps";
      displayManager.sessionCommands = ''
         ${pkgs.xorg.xset}/bin/xset r rate 250 50
       '';
      #autoRepeatDelay = 250;
      #autoRepeatInterval = 20;
      desktopManager = {
        gnome.enable = true;
      };
    };

    openssh = {
      enable = true;
      forwardX11 = true;
      gatewayPorts = "yes";
    };

  };

  system.stateVersion = stateVersion;

  time.timeZone = "Asia/Seoul";

}
