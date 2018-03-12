# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # gummiboot efi boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
#    kernel.sysctl."net.ipv4.ip_forward" = 1;
  };

  powerManagement.powerUpCommands = "${pkgs.hdparm}/sbin/hdparm -a0 -B 255 /dev/sda";

  # networking
  networking.hostName = "nixos-genis";
#  networking.networkmanager.enable = true;
#  networking.firewall = {
#    enable = true;
#    allowPing = true;
#    allowedTCPPorts = [ 445 139 25565 21027 22000 5900 4711 24800 ];
#    allowedUDPPorts = [ 137 138 ];
#    allowedUDPPortRanges = [
#      { from = 60000; to = 61000; }
#      { from = 9993; to = 9993;}
#    ];
#  };
# 
  # i18n
  i18n = {
    consoleFont = "latarcyrheb-sun32";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      source-code-pro
#      corefonts
      inconsolata
      ubuntu_font_family
      baekmuk-ttf
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
    ];
  };

  # time zone.
  time.timeZone = "Asia/Seoul";

  # packages 
  environment.systemPackages = with pkgs; [
    wget vim w3m tmux emacs
  ];

  # rfkill bug fix 
#  systemd.additionalUpstreamSystemUnits = [ "systemd-rfkill.socket" ];

  # virtualisation
#  virtualisation.docker.enable = true;

#  environment.etc = {
#    "synergy-server.conf".text = ''
#      section: screens
#        z40:
#        macth68.cern.ch:
#          alt = super
#          super = alt
#      end
#      section: links
#        z40:
#          right = macth68.cern.ch
#        macth68.cern.ch:
#          left = z40
#      end
#      section: options
#        keystroke(super+h) = switchInDirection(left)
#        keystroke(super+l) = switchInDirection(right)
#      end 
#    '';
#  };

#  systemd.services.synergy-server.serviceConfig.User="jhhuh";
 
  # services
  services = {
     xserver = {
       enable = true;
       desktopManager = {
         default = "plasma5";
         plasma5.enable = true;
       };
     };
#    synergy.server = {
#      enable = true;
#      address = "192.168.2.4";
#      screenName = "z40";
#    };
#    
#    xserver = {
#      enable = true;
#      dpi = 157;
#      layout = "us";
#      xkbOptions = "ctrl:swapcaps";
#
#      libinput.enable = true;
# 
#      desktopManager = {
#        xfce.enable = true;
#        xterm.enable = false;
#        default = "xfce";
#      };
#
#      displayManager.sddm.enable = true;
#      displayManager.gdm.enable = true;

#      libinput.enable = false;
#      multitouch = {
#        enable = true;
#        additionalOptions = ''
#          Option "Sensitivity" "0.64"
#          Option "FingerHigh" "5"
#          Option "FingerLow" "1"
#          Option "IgnoreThumb" "true"
#          Option "IgnorePalm" "true"
#          Option "DisableOnPalm" "true"
#          Option "TapButton1" "1"
#          Option "TapButton2" "3"
#          Option "TapButton3" "2"
#          Option "TapButton4" "0"
#          Option "ClickFinger1" "1"
#          Option "ClickFinger2" "2"
#          Option "ClickFinger3" "3"
#          Option "ButtonMoveEmulate" "false"
#          Option "ButtonIntegrated" "true"
#          Option "ClickTime" "25"
#          Option "BottomEdge" "30"
#          Option "SwipeLeftButton" "8"
#          Option "SwipeRightButton" "9"
#          Option "SwipeUpButton" "0"
#          Option "SwipeDownButton" "0"
#          Option "ScrollDistance" "75"
#          Option "VertScrollDelta" "-10"
#          Option "HorizScrollDelta" "-10"
#        '';
#      };
#    };

#    syncthing = {
#      enable = true;
#      user = "jhhuh";
#      dataDir = "/home/jhhuh/.config/syncthing";
#    };

#    postgresql = {
#      enable = true;
#    };
#
    #fail2ban.enable = true;

#    samba = {
#      enable = true;
#      shares = {
#        Videos =
#          { path = "/home/tominji/share/videos";
#            #"read only" = "yes";
#            browseable = "yes";
#            "guest ok" = "yes";
#          };
#      };
#      extraConfig = ''
#      guest account = smbguest
#      map to guest = bad user
#      '';
#  };
 
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

#  programs.ssh.setXAuthLocation = true;
  
  # user account
  users.extraUsers.jhhuh = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    uid = 1000;
  };
  
  users.extraUsers.tominji = {
    isNormalUser = true;
  };
  
#  users.users.smbguest = 
#    { name = "smbguest";
#      uid  = config.ids.uids.smbguest;
#      description = "smb guest user";
#    }; 

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.09";
}
