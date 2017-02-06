# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/hardware/network/broadcom-43xx.nix>
      <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot = {
    initrd = {
      availableKernelModules = [
#        "xhci_pci" "ahci"
#        "usb_storage" "usbhid"
#        "sd_mod"
      ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    kernelParams = [
      "i915_enable_rc6=1"
      "i915_enable_fbc=1"
      "lvds_downclock=1"
      "nmi_watchdog=0"
      "acpi_osi=\"!Darwin\""
    ];
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/0387bfb7-581d-44de-b1fb-650c5e801bf6";
      fsType = "ext4";
    };
  
  swapDevices = [
    { device = "/dev/disk/by-uuid/0ca40567-ccde-4c9e-9ac6-7a42d7bdef99"; }
  ];

  nix.maxJobs = lib.mkDefault 4;
}
