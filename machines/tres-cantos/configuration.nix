# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

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

  nix.trustedUsers = [ "root" "@wheel" ];
  nix.extraOptions = "experimental-features = nix-command flakes";

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

  services = {
    tailscale.enable = true;

    ipfs.enable = true;

     xserver = {
       enable = true;
       xkbOptions = "ctrl:swapcaps";
       displayManager.sessionCommands = ''
         ${pkgs.xlibs.xset}/bin/xset r rate 250 50
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

  security.pam.enableSSHAgentAuth = true;

  users.users."jhhuh" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" ];
    uid = 1000;
  };

  system.stateVersion = "22.05";
  time.timeZone = "Asia/Seoul";
}
