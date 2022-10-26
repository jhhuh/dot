# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "p1gen3"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Seoul";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

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


  nixpkgs = {
    config.allowUnfree = true;
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

  # Enable the X11 windowing system.
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

  # Configure keymap in X11
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;

  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.prime.sync.enable = true;
  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    noto-fonts-extra
    noto-fonts-cjk
    ubuntu_font_family
    hack-font
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    tmux
    wget
    home-manager
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.slock.enable = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    #listenAddresses = [ { addr = "100.94.44.110"; port = 22; } ];
  };

  services.tailscale.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall.checkReversePath = "loose";

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

