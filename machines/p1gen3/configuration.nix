{ config, pkgs, stateVersion, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_6_1;

  boot.kernelParams = [
    # ''wireguard.dyndbg="module wireguard +p"''
    #"i915.enable_psr=0"
    "nvme_core.default_ps_max_latency_us=0"
  ];

  networking.hostName = "p1gen3";
  networking.networkmanager.enable = true;

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

#  security.pam.enableSSHAgentAuth = true;

  nixpkgs = {
    overlays = [
      (self: super: {
        slock = (super.slock.overrideAttrs (old: {
          src = self.fetchurl {
            url = "https://github.com/khuedoan/slock/archive/37f091cb167f719103ef70baa6b46b95645e5b95.tar.gz";
            sha256 = "bofSIuM/dEZNyiIuzgxAGqfN1F7DMvhuZlE2h9mbouQ=";
          };
        })).override {
          conf = ''
            /* user and group to drop privileges to */
            static const char *user  = "nobody";
            static const char *group = "nobody";
           
            static const char *colorname[NUMCOLS] = {
                [INIT] =   "#000000",   /* after initialization */
                [INPUT] =  "#282c34",   /* during input */
                [FAILED] = "#be5046",   /* wrong password */
            };

            /* lock screen opacity */
            static const float alpha = 1.;

            /* treat a cleared input like a wrong password (color) */
            static const int failonclear = 1;

            /* default message */
            static const char * message = "Enter password to unlock";

            /* text color */
            static const char * text_color = "#abb2bf";

            /* text size (must be a valid size) */
            static const char * text_size = "fixed";
            '';
          };
        })
    ];
  };

  networking.wireguard.enable = true;
  networking.wireguard.interfaces = {
    "wg-hds0" = {
      generatePrivateKeyFile = true;
      privateKeyFile = "/root/wg-hds0.privateKey";
      ips = [ "20.20.20.2" ];
      peers = [
        {
          publicKey = "i0ZorMa8S9fT8/TI/U01K5HGhYPGRESnrq36k2I7MBU=";
          allowedIPs = [ "20.20.0.0/16"]; #[ "20.20.100.1/32" "20.20.100.2/32" ];
          endpoint = "121.136.244.64:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  services.fwupd.enable = true;
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  services.kmscon = {
      enable = true;
      hwRender = true;
      extraConfig = ''
        font-dpi=192
        xkb-options=ctrl:swapcaps
      '';   
    };

  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.xmonad.enableContribAndExtras = true;

  #services.xserver.displayManager.sddm.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  #services.xserver.desktopManager.cde.enable = true;
  #services.xserver.desktopManager.lxqt.enable = true;
  #services.xserver.desktopManager.pantheon.enable = true;
  #services.xserver.desktopManager.lumina.enable = true;
  #services.xserver.desktopManager.lumina.enable = true;
  #services.xserver.desktopManager.cinnamon.enable = true;
  
  services.xserver.xkbOptions = "ctrl:swapcaps";

  services.xserver.layout = "us";

  # services.printing.enable = true;

  sound.enable = true;

  hardware = {
    acpilight.enable = true;
    bluetooth.enable = true;
    enableAllFirmware = true;
    pulseaudio = {
      enable = true;
      extraModules = [];
      package = pkgs.pulseaudioFull;
    };
    trackpoint = {
      enable = true;
      emulateWheel = true;
      device = "TPPS/2 Elan TrackPoint";
    };
  };

  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;

  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.prime.sync.enable = true;
  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  services.upower.enable = true;

  services.xserver.libinput.enable = false;

  services.logind.extraConfig = ''
    RuntimeDirectorySize=4G
  '';

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    noto-fonts-extra
    noto-fonts-cjk
    ubuntu_font_family
    hack-font
  ];

  environment.systemPackages = with pkgs; [
    vim
    git
    tmux
    wget
    home-manager
  ];

  # # See https://github.com/balsoft/nixos-fhs-compat
  # environment.fhs.enable = true;
  # environment.fhs.linkLibs = true;
  # environment.lsb.enable = true;
  # environment.lsb.support32Bit = true;

  programs.slock.enable = true;

  services.openssh = {
    enable = true;
  };

  services.prometheus = {
    enable = true;
    port = 9001;
    scrapeConfigs = [ {
      job_name = "admin";
      static_configs = [
        {
          targets = [
            "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
          ];
        }
      ];
    } ];
  };

  services.prometheus.exporters = {
    node = {
      enable = true;
      enabledCollectors = [ "systemd" ];
      port = 9002;
    };
  };

  networking.firewall = {
    trustedInterfaces = [ "wg-hds0" ];
  };

  virtualisation = {
    virtualbox.host.enable = true;
    virtualbox.host.enableExtensionPack = true;
  };

  system.copySystemConfiguration = false;

  system.stateVersion = stateVersion;

}

