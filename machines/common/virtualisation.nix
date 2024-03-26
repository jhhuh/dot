{ ... }:

{

  programs.virt-manager.enable = true;

  virtualisation = {
    podman.enable = true;
    podman.dockerCompat = true;
    podman.dockerSocket.enable = true;

    libvirtd.enable = true;

    incus.enable = true;
    incus.preseed = {
      networks = [
        {
          name = "incusbr0";
          type = "bridge";
          config = {
            "ipv4.address" = "10.0.100.1/24";
            "ipv4.nat" = "true";
          };
        }
      ];
      profiles = [
        {
          name = "default";
          devices = {
            eth0 = {
              name = "eth0";
              network = "incusbr0";
              type = "nic";
            };
            root = {
              path = "/";
              pool = "default";
              size = "35GiB";
              type = "disk";
            };
          };
        }
      ];
      storage_pools = [
        {
          name = "default";
          config = {
            source = "/var/lib/incus/storage-pools/default";
          };
          driver = "dir";
        }
      ];
    };
  };

}
