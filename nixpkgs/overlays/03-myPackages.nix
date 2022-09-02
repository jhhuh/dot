self: super: rec {

  farbfeld-utils = let
    farbfeld-utils-nix = {stdenv, fetchzip, xorg, SDL, ghostscript, sqlite}:
      stdenv.mkDerivation {
        name = "farbfeld";

        src = fetchzip {
          url = "http://zzo38computer.org/prog/farbfeld.zip";
          sha256 = "sha256-guxTyZmi6w4jrGp+sdLddAur+PJUV3sUoyXC0lmC1LA=";
          stripRoot = false;
        };

        buildInputs = [ xorg.libX11 SDL ghostscript sqlite ];

        buildPhase = ''
        mkdir ./bin

        ls *.c \
          | xargs grep --no-filename "^gcc " \
          | sed -e "s#~/bin#./bin#" \
          | xargs -I {} sh -c "echo -e \"echo -e {}\n{}\"" \
          > ./build.sh

        substituteInPlace ./build.sh \
          --replace sqlite3.o ${sqlite.out}/lib/libsqlite3.so.0 \
          --replace /usr/lib/libgs.so.9 ${ghostscript}/lib/libgs.so.9

        gcc -c ./lodepng.c

        source ./build.sh

      '';

        installPhase = ''
        mkdir -p $out/bin
        cp ./bin/* $out/bin
      '';
      };
  in self.callPackage farbfeld-utils-nix {};


  pixiecore = self.callPackage ../pixiecore {};

  slock = super.slock.overrideAttrs (old: {
    src = self.fetchurl {
      url = "https://github.com/khuedoan/slock/archive/37f091cb167f719103ef70baa6b46b95645e5b95.tar.gz";
      sha256 = "bofSIuM/dEZNyiIuzgxAGqfN1F7DMvhuZlE2h9mbouQ=";
    };
  });


  mouser = let
    _mouser = { clangStdenv, fetchFromGitHub, boost, xorg }: clangStdenv.mkDerivation rec {
      name = "mouser-${version}";
      version = "HEAD";
      src = fetchFromGitHub {
        owner = "blak3mill3r";
        repo = "mouser";
        rev = "32a2392f753d72e7d59422ee671cdc36e01760dc";
        sha256 = "0wj3n70z8xn78z5ks7wjfl712c98k4jgil9grl669mmyc1l49hib";
      };
      buildInputs = [ boost ] ++ (with xorg; [ libX11 libXtst libXi ]);
      installPhase = ''
        mkdir -p $out/bin
        cp ./mouser $out/bin/
      '';
    };
  in self.callPackages _mouser {};

  texmacs = super.texmacs.override { koreanFonts = true; };

  nbstripout = self.callPackages ../nbstripout {};

  #  vimb-unwrapped = self.callPackages ../vimb {};
  #
  st-flexipatch = super.st.overrideAttrs (old:
    let
      inherit (self) fetchFromGitHub;

      wallpaper-ff =
        let
          inherit (self) runCommand farbfeld farbfeld-utils;
          wallpaper-jpg = ../../wallpaper.jpg;
        in runCommand "wallpaper.ff" {
          inherit wallpaper-jpg;
          buildInputs = [ farbfeld farbfeld-utils ]; }
          "jpg2ff < ${wallpaper-jpg} | ff-border e 50 | ff-bright rgba 0 0.9 1 | ff-blur 50 15 > $out";

      pixelsize = 14;

    in
      {

        src = fetchFromGitHub {
          owner = "bakkeby";
          repo = "st-flexipatch";
          rev = "34cd955f148709e5adc5fce380f6528944f144e2";
          hash = "sha256-R5NZ/9c2uea1WxZ5sFvlCf+zzFvo7E3CM4iiXLYZasA=";
        };

        postPatch = ''
          substituteInPlace patches.def.h \
            --replace "BACKGROUND_IMAGE_PATCH 0" "BACKGROUND_IMAGE_PATCH 1" \
            --replace "SIXEL_PATCH 0" "SIXEL_PATCH 1" \
            --replace "ALPHA_PATCH 0" "ALPHA_PATCH 1" \
            --replace "ALPHA_FOCUS_HIGHLIGHT_PATCH 0" "ALPHA_FOCUS_HIGHLIGHT_PATCH 0"

          substituteInPlace config.mk \
            --replace "#SIXEL_C" "SIXEL_C"

          substituteInPlace config.def.h \
            --replace "/path/to/image.ff" "${wallpaper-ff}" \
            --replace "pseudotransparency = 0" "pseudotransparency = 1" \
            --replace "float alpha = 0.8;" "float alpha = 0.8;" \
            --replace ":pixelsize=12:" ":pixelsize=${toString pixelsize}:"
      '';});

  st = let
    patches = let inherit (self) fetchurl; in {

      dracula = fetchurl {
        url = "https://st.suckless.org/patches/dracula/st-dracula-0.8.5.diff";
        sha256 = "0ldy43y2xa8q54ci6ahxa3iimfb4hmjsbclkmisx0xjr88nazzhz";
      };

      nord = fetchurl {
        url = "https://st.suckless.org/patches/nordtheme/st-nordtheme-0.8.5.diff";
        sha256 = "Tlpp1HD4vl/c88UxI1t4rS7nDEzMkDeyW7/opIv4Rf8=";
      };

      background-image = fetchurl {
        url = "https://st.suckless.org/patches/background_image/st-background-image-0.8.5.diff";
        sha256 ="19a5dq1vyhviyvi7qr7w679r53vgvfypdv2bkx1h2p6zkgbzys0j";
      };

      fullscreen = fetchurl {
        url = "https://st.suckless.org/patches/fullscreen/st-fullscreen-0.8.5.diff";
        sha256 = "1njsd4nv5lxxyc7a3fawf7jz585bwwqlqnvggwmc4zb25bcz92gq";
      };

    };
    
    wallpaper-ff =
      let
        inherit (self) runCommand farbfeld farbfeld-utils;
        wallpaper-jpg = ../../wallpaper.jpg;
      in runCommand "wallpaper.ff" {
        inherit wallpaper-jpg;
        buildInputs = [ farbfeld farbfeld-utils ]; }
        "jpg2ff < ${wallpaper-jpg} | ff-border e 50 | ff-bright rgba 0 0.5 1 | ff-blur 50 15 > $out";

    pixelsize = 14;

  in (super.st.override {
    patches = [
      patches.dracula
      patches.background-image
      patches.fullscreen
    ];}).overrideAttrs (_: {
        postPatch = ''
          substituteInPlace config.def.h \
            --replace "/path/to/image.ff" "${wallpaper-ff}" \
            --replace "pseudotransparency = 0" "pseudotransparency = 1" \
            --replace ":pixelsize=12:" ":pixelsize=${toString pixelsize}:"
      '';});

  myEmacs = self.emacsWithPackages (epkg: with epkg; [ emacs-libvterm ]);

  #  webkitgtk = self.callPackage ../webkitgtk (with self; {
  #    harfbuzz = harfbuzzFull;
  #    inherit (gst_all_1) gst-plugins-base gst-plugins-bad;
  #    stdenv = overrideCC stdenv gcc6;
  #    gobject-introspection = gobjectIntrospection;
  #  });
  #
  #  vimb-unwrapped = self.callPackage ../vimb {};

  uzbl = super.uzbl.override { webkit = self.webkitgtk; };

  tinyemu = self.callPackage ../tinyemu {};

  snack-exe = let
    src = self.fetchFromGitHub {
      owner = "nmattia";
      repo = "snack";
      rev = "08861356442d867d3bdcd217c4521c53264388c0";
      sha256 = "0jmdsz44s2a0x7nlm03phkswp5gvk95vdgqq294rwn93n0ssyz6r";
    };
    snack-lib = self.callPackage "${src}/snack-lib" { inherit (self.haskellPackages) ghcWithPackages; };
  in snack-lib.executable "${src}/bin/package.nix" // { name = "snack-exe"; }; 

  x230_icc = self.fetchurl rec {
    name = "lp125wf2-spb2.icc";
    url = with meta; "https://github.com/${owner}/${repo}/blob/${rev}/${name}?raw=true";
    sha256 = "18lidz1k98344i5z6m7mf8sl12syzvrzrlpbjm7hmhhyv96a44rc";
    meta = {
      owner = "soleblaze";
      repo = "icc";
      rev = "77775bfdeb08a73ba74db6457610be2859b7ce6f";};};
  
  xhk = self.callPackage ../xhk {};
  
  firefox-devedition-bin-unwrapped = (super.firefox-devedition-bin-unwrapped.overrideAttrs (attr:{
    libPath = self.lib.makeLibraryPath (with self.xorg; [ libXcursor libXi ]) + ":" + attr.libPath;
  })).override {
    generated = import ../firefox-devedition-update/devedition_sources.nix;
  };
  
  vban = self.callPackage ../vban {};
  # rxvt_unicode = super.rxvt_unicode.overrideAttrs (old: {
  #   version = "2020-02-12";
  #   src = super.fetchcvs {
  #     cvsRoot = ":pserver:anonymous@cvs.schmorp.de/schmorpforge";
  #     module = "rxvt-unicode";
  #     date = "2020-02-12";
  #     sha256 = "0n8z3c8fb1pqph09fnl9msswdw2wqm84xm5kaax6nf514gg05dpx";
  #   };
  # });

  nimf = let
    nimf_pkg = { stdenv, fetchgit, which
               , file
               , pkgconfig
               , autoreconfHook 
               , glib
               # , libtool
               , gtk-doc, intltool
               , libhangul, anthy
               #, autoconf, automake
               , libxkbcommon, m17n_db, m17n_lib, librime
               , qtbase , qt4
               , gtk3, gtk3-x11, gtk2
               , librsvg
               , libxklavier
               , libappindicator }:
                 stdenv.mkDerivation {
                   pname = "nimf";
                   version = "HEAD";
                   
                   src = fetchgit {
                     url = "https://gitlab.com/nimf-i18n/nimf.git";
                     rev = "dec1a11c3034677a825b0dff319a05a8d019ae08";
                     sha256 = "14ci4pffzq28zd2d1nvm4f9d2hr1m939lg78n67p8qbra68jl7qc";
                   };

                   buildInputs = [ glib gtk-doc intltool libhangul anthy libxkbcommon # libtool
                                   m17n_db m17n_lib librime qtbase qt4
                                   gtk3 gtk3-x11 gtk2
                                   librsvg libxklavier libappindicator
                                 ];
                   nativeBuildInputs = [ which file autoreconfHook pkgconfig ]; # automake ];

                   patches = [ ../patches/nimf.patch ];

                   QT5_IM_MODULE_DIR = "${qtbase.bin}/lib/qt-${qtbase.version}/plugins/platforminputcontexts";
                   GTK3_DEVDIR = "${gtk3.dev}";
                   GTK2_DEVDIR = "${gtk2.dev}";
                   GTK3_DIR = "${gtk3}";

                   postPatch = ''
          cp -a ${gtk-doc}/share/gtk-doc/data/gtk-doc.make .
          substituteInPlace ./configure.ac --replace /usr/share/anthy/anthy.dic ${anthy}/share/anthy/anthy.dic
        '';

                   autoreconfPhase = ''
          ./autogen.sh
          substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file
        '';

                   # preConfigure = ''
                   #   substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file"
                   # '';
                 };
  in self.libsForQt5.callPackage nimf_pkg {};

  lyx = let
    version = "2.3.4.3";
    pname = "lyx";
    src = self.fetchurl {
      url = "https://ftp.lip6.fr/pub/lyx/stable/2.3.x/${pname}-${version}.tar.gz";
      sha256 = "0fxygsjb4550p48a23khc7rmz980c42kci9arq6y7vk9d41c22j5";
    };
  in super.lyx.overrideAttrs (attrs: {
    inherit version pname src;
    patches = [];
  });
  
}
