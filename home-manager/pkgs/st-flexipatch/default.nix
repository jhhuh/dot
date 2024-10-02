{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, fontconfig
, freetype
, libX11
, libXft
, imlib2Full
, ncurses
, writeText
, conf ? null
, patches ? [ ]
, patchNames ? [
  #"ALPHA"
  #"ALPHA_FOCUS_HIGHLIGHT"
  #"ALPHA_GRADIENT"
  #"ANYGEOMETRY"
  #"ANYSIZE"
  #"ANYSIZE_SIMPLE"
  #"BACKGROUND_IMAGE"
  #"BACKGROUND_IMAGE_RELOAD"
  #"BLINKING_CURSOR"
  #"BOLD_IS_NOT_BRIGHT"
  #"BOXDRAW"
  #"CLIPBOARD"
  #"COLUMNS"
  #"COPYURL"
  #"COPYURL_HIGHLIGHT_SELECTED_URLS"
  #"CSI_22_23"
  #"DEFAULT_CURSOR"
  #"DELKEY"
  #"DISABLE_BOLD_FONTS"
  #"DISABLE_ITALIC_FONTS"
  #"DISABLE_ROMAN_FONTS"
  #"DYNAMIC_CURSOR_COLOR"
  #"EXTERNALPIPE"
  #"EXTERNALPIPEIN"
  #"FIXKEYBOARDINPUT"
  #"FONT2"
  #"FULLSCREEN"
  #"HIDECURSOR"
  #"HIDE_TERMINAL_CURSOR"
  #"INVERT"
  #"ISO14755"
  #"KEYBOARDSELECT"
  #"LIGATURES"
  #"MONOCHROME"
  #"NETWMICON"
  #"NETWMICON_FF"
  #"NETWMICON_LEGACY"
  #"NEWTERM"
  #"NO_WINDOW_DECORATIONS"
  #"OPENCOPIED"
  #"OPENURLONCLICK"
  #"OSC133"
  #"REFLOW"
  #"RELATIVEBORDER"
  #"RIGHTCLICKTOPLUMB"
  #"SCROLLBACK"
  #"SCROLLBACK_MOUSE"
  #"SCROLLBACK_MOUSE_ALTSCREEN"
  #"SELECTION_COLORS"
  #"SINGLE_DRAWABLE_BUFFER"
  #"SIXEL"
  #"ST_EMBEDDER"
  #"SPOILER"
  #"SWAPMOUSE"
  #"SYNC"
  #"THEMED_CURSOR"
  #"UNDERCURL"
  #"UNIVERSCROLL"
  #"USE_XFTFONTMATCH"
  #"VERTCENTER"
  #"VISUALBELL_1"
  #"W3M"
  #"WIDE_GLYPHS"
  #"WIDE_GLYPH_SPACING"
  #"WORKINGDIR"
  #"XRESOURCES"
  #"XRESOURCES_RELOAD"
]
, extraLibs ? [ ]
, nixosTests
# update script dependencies
, gitUpdater
}:

let
  enable-by-patch-name = patch-name:
  ''
    substituteInPlace patches.def.h\
      --replace "#define ${patch-name}_PATCH 0" "#define ${patch-name}_PATCH 1"
  '';
in

stdenv.mkDerivation (finalAttrs: {
  pname = "st-flexipatch";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "bakkeby";
    repo = "st-flexipatch";
    rev = "3f1a5ed034b65e8d9542e506bb7e85ed1fd4303c";
    hash = "sha256-GY1Vw6ZPOOgSNWzHRIUz/nTAykPPzr0lpr8BNzpr6KM=";
  };

  outputs = [ "out" "terminfo" ];

  inherit patches;

  configFile = lib.optionalString (conf != null)
    (writeText "config.def.h" conf);

  postPatch =
    ''
      substituteInPlace config.mk \
        --replace "#SIXEL_C = sixel.c sixel_hls.c" "SIXEL_C = sixel.c sixel_hls.c" \
        --replace "#SIXEL_LIBS = `$(PKG_CONFIG) --libs imlib2`" "SIXEL_LIBS = `$(PKG_CONFIG) --libs imlib2`"
    '' #TODO: make it conditional
    + lib.optionalString (conf != null) "cp ${finalAttrs.configFile} config.def.h"
    + ''
      ${__concatStringsSep "\n" (map enable-by-patch-name patchNames)}
    ''
    + lib.optionalString stdenv.isDarwin ''
    substituteInPlace config.mk --replace "-lrt" ""
  '';

  strictDeps = true;

  makeFlags = [
    "PKG_CONFIG=${stdenv.cc.targetPrefix}pkg-config"
  ];

  nativeBuildInputs = [
    pkg-config
    ncurses
    fontconfig
    freetype
  ];

  buildInputs = [
    libX11
    libXft
    imlib2Full
  ] ++ extraLibs;

  preInstall = ''
    export TERMINFO=$terminfo/share/terminfo
    mkdir -p $TERMINFO $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
  '';

  installFlags = [ "PREFIX=$(out)" ];

})
