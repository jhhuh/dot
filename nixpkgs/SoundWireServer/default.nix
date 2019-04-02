{stdenv, fetchurl, portaudio, curl, qt4, autoPatchelfHook}:

stdenv.mkDerivation rec {
  name = "SoundWireServer-${version}";
  version = "2.1.2";
  src = fetchurl {
    url = "http://georgielabs.altervista.org/SoundWire_Server_linux64.tar.gz";
    sha256 = "104cs4xqkdq1szlb40f8axzfjdl0d5a7svw1g81npayq91hf6pbv";
  };
  buildInputs = [ stdenv portaudio curl qt4 autoPatchelfHook ];
  installPhase = ''
    mkdir -p $out/bin/
    mkdir -p $out/share/SoundWireServer/
    cp * $out/share/SoundWireServer
    mv $out/share/SoundWireServer/SoundWireServer $out/bin/
    mv $out/share/SoundWireServer/*.bmp $out/bin/
  '';
}
  
