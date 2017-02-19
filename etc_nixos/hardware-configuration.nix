# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/a8742633-56e1-4b1f-8543-3499779dab6f";
      fsType = "xfs";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/5a93167d-f45c-42cd-a46f-5f58595d25a4"; }
    ];

  nix.maxJobs = lib.mkDefault 4;
}
