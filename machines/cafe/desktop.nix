{ config, lib, pkgs, ... }:

{

  services = {

    openssh.enable = true;
    openssh.forwardX11 = true;

    xserver = {

      enableTCP = true;

      videoDrivers = [ "nvidia" ];

      enable = true;

      windowManager.xmonad.enable = true;
      windowManager.xmonad.enableContribAndExtras = true;

      desktopManager.xterm.enable = true;
      desktopManager.gnome.enable = true;

      xkbOptions = "ctrl:swapcaps";

    };


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
}
