{ rustPlatform, fetchFromGitHub, pkg-config, openssl, mpv-unwrapped }:

let

  mpv-0341 = import ./mpv-0341.nix { inherit mpv-unwrapped fetchFromGitHub; };

in

rustPlatform.buildRustPackage rec {

  pname = "ytui-music";
  version = "v2.0.0-rc1";

  src = fetchFromGitHub {
    owner = "sudipghimire533";
    repo = pname;
    rev = version;
    hash = "sha256-f/23PVk4bpUCvcQ25iNI/UVXqiPBzPKWq6OohVF41p8=";
  };

  cargoLock.lockFile = "${src}/Cargo.lock";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl mpv-0341 ];

  doCheck = false;

}
