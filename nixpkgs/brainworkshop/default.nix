{ stdenv, fetchurl
, pythonPackages
, mesa_noglu, openal, fontconfig
, unzip, dos2unix
, makeWrapper }:

stdenv.mkDerivation rec {
    name = "brainworkshop-${version}";
    version = "4.8.7";
    src = fetchurl {
      url = "mirror://sourceforge/brainworkshop/brainworkshop-${version}.zip";
      sha256 = "0ld590ixmlvfwadghiq6n3xn7fmgakmplyi267ghj1r5a4hfzbgb";
    };

    nativeBuildInputs = [ unzip dos2unix makeWrapper];
    buildInputs = [ mesa_noglu openal fontconfig ]
      ++ (with pythonPackages; [ pyglet ]);
  
    patchPhase = ''
      dos2unix brainworkshop.pyw
      substituteInPlace brainworkshop.pyw --replace "halign=" "align=" --replace "from pyglet.media import avbin" "raise ImportError" --replace "print _(" "#print _("
    '';
    
    installPhase = ''
      rm -rf pyglet 
      chmod +x brainworkshop.pyw
      mkdir -p $out/brainworkshop
      cp -r . $out/brainworkshop/
      
      substituteInPlace $out/brainworkshop/brainworkshop.pyw --replace "/usr/bin/env python" "${pythonPackages.python.interpreter}"

      mkdir $out/bin
      makeWrapper $out/brainworkshop/brainworkshop.pyw $out/bin/brainworkshop --set PYTHONPATH $PYTHONPATH --prefix PATH ":" "$PATH" --set LD_LIBRARY_PATH ${stdenv.lib.makeLibraryPath buildInputs}
    '';
  }
