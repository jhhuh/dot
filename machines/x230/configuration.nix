{ config, pkgs, modulesPath, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  nixpkgs = {
    overlays = [
     # (self: super: {
     #   firmwareLinuxNonfree = self.runCommandNoCC "firmware-linux-nonfree" {} ''
     #     mkdir -p $out/lib/firmware
     #     cp -R ${super.firmwareLinuxNonfree.out}/lib/firmware/* $out/lib/firmware/
     #     rm $out/lib/firmware/iwlwifi-*.pnvm
     #   '';})
      ];
    config.allowUnfree = true;
  };


  nix = {
    package = pkgs.nixFlakes;

    # Enable experimental version of nix with flakes support
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';

    trustedUsers = [ "@wheel" ];
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "vm.laptop_mode=5" ];
    loader = {
      grub = {
        enable = true;
        version = 2;
        #efiSupport = true;
        #efiInstallAsRemovable = true;
        device = "/dev/sda";
        useOSProber = true;
      };
      #efi.efiSysMountPoint = "/boot/efi";
    };
    supportedFilesystems = [ "ntfs" ];
  };

  hardware = {
    bluetooth.enable = true;
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
    trackpoint = {
      emulateWheel = true;

    };
  };

  time.timeZone = "Asia/Seoul";

  networking = {
    hostName = "x230"; # Define your hostname.
    useDHCP = false;
    networkmanager = {
      enable = true;
      extraConfig = ''
        [modem-manager]
        Identity=unix-group:networkmanager
        Action=org.freedesktop.ModemManager*
        ResultAny=yes
        ResultInactive=no
        ResultActive=yes
      '';
    };
    interfaces.enp0s25.useDHCP = true;
    firewall.allowedTCPPorts = [ 5900 ];
    firewall.trustedInterfaces = [ "tailscale0" ];
  };

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    useXkbConfig = true;
  };

  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    terminus_font
    terminus_font_ttf
    terminus-nerdfont
    corefonts
    noto-fonts-cjk
    ubuntu_font_family
  ];

  programs = {
    slock.enable = true;
    mosh.enable = true;
    ssh.startAgent = true;
  };

  services = {
    xfs.enable = true;
    dbus.packages = [ pkgs.miraclecast ];
#    logind.lidSwitch = "ignore";
#    acpid = {
#      enable = true;
#      logEvents = true;
#      powerEventCommands = ''
#        /run/current-system/sw/bin/systemctl suspend
#      '';
#    };
    illum.enable = true;
    thinkfan = {
      enable = true;
      sensors = [
        { type = "hwmon";
          query = "/sys/devices/virtual/thermal/thermal_zone0/temp";
        } ];
    };
    openssh.enable = true;
    tailscale.enable = true;
    xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
      desktopManager.xterm.enable = true;
      windowManager.xmonad.enable = true;
      xkbOptions = "ctrl:swapcaps";
      libinput.enable = false;
    };
  };

  i18n.inputMethod.enabled = "kime";

  users.users."jhhuh" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "vboxusers" ];
  };

  environment.systemPackages = with pkgs; [
    xorg.xfs wget vim tmux git
  ];

  virtualisation = {
    virtualbox.host = {
      #enable = true;
      enableExtensionPack = true;
    };
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  powerManagement = {
    cpuFreqGovernor = "ondemand";
    powertop.enable = true;
    scsiLinkPolicy = "med_power_with_dipm";
  };

  system.stateVersion = "22.05";

}

