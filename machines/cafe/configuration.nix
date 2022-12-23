{ config, pkgs, stateVersion, ... }:

{

  networking.hostName = "cafe";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Seoul";

  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.kernelParams = [];

  boot.cleanTmpDir = true;

  zramSwap.enable = true;

  services = {

    openssh.enable = true;
    openssh.forwardX11 = true;

    xserver = {

      videoDrivers = [ "nvidia" ];

      enable = true;

      windowManager.xmonad.enable = true;

      desktopManager.plasma5.enable = true;

      xkbOptions = "ctrl:swapcaps";

    };

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

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod.enabled = "kime";
  };

  sound.enable = true;

  hardware = {

    opengl.enable = true;

    opengl.driSupport32Bit = true;

    bluetooth.enable = true;

    enableAllFirmware = true;

    pulseaudio = {
      enable = true;
      extraModules = [];
      package = pkgs.pulseaudioFull;
    };

  };

  nixpkgs.config.allowUnfree = true;

  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  networking.firewall.checkReversePath = "loose";

  system.stateVersion = stateVersion;

}

