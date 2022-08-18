{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pixiecore";
  version = "2022-08-02";
  rev = "fc2840fa7b05c2f2447452e0dcc35a5a76f6acfa";

  src = fetchFromGitHub {
    owner = "danderson";
    repo = "netboot";
    inherit rev;
    sha256 = "TV0GJqhg/KEmbJzbaHD/WkSLeOx3GoVEidPrepN0P4Q=";
  };

  vendorSha256 = "sha256-hytMhf7fz4XiRJH7MnGLmNH+iIzPDz9/rRJBPp2pwyI=";

  doCheck = false;

  subPackages = [ "cmd/pixiecore" ];

  meta = {
    description = "A tool to manage network booting of machines";
    homepage = "https://github.com/danderson/netboot/tree/master/pixiecore";
    license =  lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bbigras danderson ];
    platforms = lib.platforms.unix;
  };
}
