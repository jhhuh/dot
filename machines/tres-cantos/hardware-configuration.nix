{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/9d40edc2-b388-47cc-bc3c-ca62d28598ce";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/5F71-36E9";
      fsType = "vfat";
    };

  fileSystems."/chia_final" =
    { device = "/dev/disk/by-uuid/19b407dd-a382-4f9c-ab8e-4390e1f9d571";
      fsType = "ext4";
    };

  swapDevices = [ ];

}
