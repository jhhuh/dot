self: super: rec {

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

  st = let
    st-ime = self.fetchurl {
      url = "https://st.suckless.org/patches/fix_ime/st-ime-20190202-3be4cf1.diff";
      sha256 = "0n4sq5xjx5shkdwv9hfwzjpiknra3076m8k1aimsjfqyw6gklnng";
    };
    st-dracula = self.fetchurl {
      url = "https://st.suckless.org/patches/dracula/st-dracula-0.8.2.diff";
      sha256 = "0zpvhjg8bzagwn19ggcdwirhwc17j23y5avcn71p74ysbwvy1f2y";
    };
    st-alpha = self.fetchurl {
      url = "https://st.suckless.org/patches/alpha/st-alpha-0.8.2.diff";
      sha256 = "11dj1z4llqbbki5cz1k1crr7ypnfqsfp7hsyr9wdx06y4d7lnnww";
    };
    st-solarized_both = self.fetchurl {
      url = "https://st.suckless.org/patches/solarized/st-solarized-both-20190128-3be4cf1.diff";
      sha256 = "1brz76qvmi0hg7zdq8jhgcmfc634hbm8h6wdh5cwi587xxdkhiqg";
    };
    st-nord = self.fetchurl {
      url = "https://st.suckless.org/patches/nordtheme/st-nordtheme-0.8.2.diff";
      sha256 = "0ssj7gsb3snk1pqfkffwc0dshrbmvf7ffqvrdi4k2p451mnqmph1";
    };
  in super.st.override {
    patches = [
      st-nord
      # st-alpha
      # st-dracula
      # st-solarized_both
    ]; };

  #  st = let
  #     version = "0.8.2-3";
  #     name = "st-${version}";
  #     src = self.fetchurl {
  #       url = "https://github.com/odknt/st/archive/${version}.tar.gz";
  #       sha256 = "0s0q6qa53llpazzrvvnnfqcc0kv6akhvc8v9ppk38rkzmyjd9avy";
  #     };
  #   in super.st.overrideDerivation (attr: { inherit version name src; });

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
