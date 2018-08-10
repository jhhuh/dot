# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ ./my-hardware-configuration.nix ];

  # gummiboot efi boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  powerManagement.powerUpCommands = "${pkgs.hdparm}/sbin/hdparm -a0 -B 255 /dev/sda";

  # i18n
  i18n = {
    consoleFont = "latarcyrheb-sun32";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  programs = {
    ssh.startAgent = true;
  }

  # networking
  networking.hostName = "nixos-genis";

  # packages
  environment.systemPackages = with pkgs; [
    pciutils hdparm powertop htop
    acpitool # system management utils
    wget git vimNox tmux # basic applications
  ];

  fonts = {
    enableFontDir = true;
    enableFontDir = true;
    fonts = with pkgs; [
      roboto-mono
      baekmuk-ttf source-han-sans-korean
      ubuntu_font_family
      google-fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      terminus_font_ttf
      inconsolata
      source-code-pro
      ttf_bitstream_vera
      open-dyslexic
      source-code-pro
    ];
  };


  services = {
     xserver = {
       enable = true;
       desktopManager = {
         default = "plasma5";
         plasma5.enable = true;
       };
     };

    tor = {
      enable = true;
      extraConfig = ''
        HiddenServiceDir /var/lib/tor/ssh
        HiddenServicePort 22 127.0.0.1:22
      '';
    };

    openssh = {
      enable = true;
      forwardX11 = true;
      gatewayPorts = "yes";
    };

    logind.extraConfig = "HandleLidSwitch=ignore";
  };

  # user account
  users.extraUsers.jhhuh = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    uid = 1000;
  };

  users.extraUsers.tominji = {
    isNormalUser = true;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.09";

  # time zone.
  time.timeZone = "Asia/Seoul";
}
