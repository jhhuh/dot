# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
#  imports = [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix> ];

  boot = {
    kernelParams = [ "ath9k.ps_enable=1" "nmi_watchdog=0" ];
    initrd.availableKernelModules = [ ]; # [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" "rtsx_usb_sdmmc"]
    extraModulePackages = [ ];
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/5bb101dc-6231-4a41-8178-e6db1fd4d37b";
      fsType = "ext4";
    };

  nix.maxJobs = lib.mkDefault 4;
}
