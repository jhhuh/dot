{ ... }:

{

  virtualisation = {
    podman.enable = true;
    podman.dockerCompat = true;
    podman.dockerSocket.enable = true;

    virtualbox.host.enable = true;
    virtualbox.host.enableExtensionPack = true;
  };

}
