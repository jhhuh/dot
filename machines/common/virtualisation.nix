{ ... }:

{

  virtualisation = {
    podman.enable = true;
    podman.dockerCompat = true;
    podman.dockerSocket.enable = true;
  };

}
