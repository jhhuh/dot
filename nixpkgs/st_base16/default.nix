{ stdenv, fetchurl, base16-st, fetchFromGitHub, pkgconfig, writeText, makeWrapper, libX11, ncurses, libXext, libXft, fontconfig, dmenu
,  font4ST ? "DejaVu Sans Mono:pixelsize=14:antialias=true:autohint=true"
,  base16theme ? "atelier-plateau-light" }:

with stdenv.lib; let
in stdenv.mkDerivation rec {
  name = "st-0.8.1";

  src = fetchurl {
    url = "https://dl.suckless.org/st/${name}.tar.gz";
    sha256 = "09k94v3n20gg32xy7y68p96x9dq5msl80gknf9gbvlyjp3i0zyy4";
  };

  inherit font4ST;
  base16theme_h="${base16-st}/build/base16-${base16theme}-theme.h";

  preBuild = ''
    cp ${./config.def.h} config.def.h
    substituteAllInPlace ./config.def.h
  '';

  nativeBuildInputs = [ pkgconfig makeWrapper ];
  buildInputs = [ libX11 ncurses libXext libXft fontconfig base16-st ];

  installPhase = ''
    TERMINFO=$out/share/terminfo make install PREFIX=$out
    wrapProgram "$out/bin/st" --prefix PATH : "${dmenu}/bin"
  '';

  meta = {
    homepage = https://st.suckless.org/;
    description = "Simple Terminal for X from Suckless.org Community";
    license = licenses.mit;
    maintainers = with maintainers; [andsild];
    platforms = platforms.linux;
  };
}
