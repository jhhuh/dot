{ config, pkgs, modulesPath, stateVersion, ... }:

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

    wireguard = {
      enable = true;


      interfaces = {
        "wg0" = {
          generatePrivateKeyFile = true;
          privateKeyFile = "/root/wg0.privateKey";
          ips = [ "20.20.20.1" ];
          peers = [
            {
              publicKey = "i0ZorMa8S9fT8/TI/U01K5HGhYPGRESnrq36k2I7MBU=";
              allowedIPs = [ "20.20.100.1/32" "20.20.100.2/32" ];
              endpoint = "121.136.244.64:51820";
              persistentKeepalive = 25;
            }
          ];
        };
      };
    };
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
    xfs.enable = false;
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

  environment.systemPackages = with pkgs; [
    xorg.xfs wget vim tmux git
  ];

  virtualisation = {
    lxd.enable = true;
    virtualbox.host = {
      enable = true;
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

  system.stateVersion = stateVersion;

}

