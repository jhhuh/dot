{ config, lib, pkgs, ... }:
{
  # services
  services = { 
    acpid.enable = true;
    
    openssh = {
      enable = true;
      forwardX11 = true;
    }; 

    tor = {
      enable = true;
      client.enable = true;
    };
   
    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "eurosign:e";
     
      desktopManager = {
        gnome3.enable = true;
        xterm.enable = false;
        default = "gnome3";
      };

      displayManager.gdm.enable = true;

      libinput.enable = false;
      multitouch = {
        enable = true;
        additionalOptions = ''
          Option "Sensitivity" "0.64"
          Option "FingerHigh" "5"
          Option "FingerLow" "1"
          Option "IgnoreThumb" "true"
          Option "IgnorePalm" "true"
          Option "DisableOnPalm" "true"
          Option "TapButton1" "1"
          Option "TapButton2" "3"
          Option "TapButton3" "2"
          Option "TapButton4" "0"
          Option "ClickFinger1" "1"
          Option "ClickFinger2" "2"
          Option "ClickFinger3" "3"
          Option "ButtonMoveEmulate" "false"
          Option "ButtonIntegrated" "true"
          Option "ClickTime" "25"
          Option "BottomEdge" "30"
          Option "SwipeLeftButton" "8"
          Option "SwipeRightButton" "9"
          Option "SwipeUpButton" "0"
          Option "SwipeDownButton" "0"
          Option "ScrollDistance" "75"
          Option "VertScrollDelta" "-10"
          Option "HorizScrollDelta" "-10"
        '';
      };
#      synaptics = {
#        enable = true;
#        additionalOptions = ''
#          Option "VertScrollDelta" "400"
#          Option "HorizScrollDelta" "500"
#          Option "AreaRightEdge" "3000"
#          Option "AreaBottomEdge" "5000"
#          Option "PalmDetect" "1"
#          Option "PalmMinWidth" "10"
#          Option "PalmMinZ" "100"
#          Option "MinSpeed" "1"
#          Option "MaxSpeed" "100"
#        '';
#        accelFactor = "0.02";
#        fingersMap = [ 1 3 2 ];
#        twoFingerScroll = true;
#      };
    };
  };
}
