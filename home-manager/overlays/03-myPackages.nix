self: super: rec {

  ghcup = self.callPackage ../pkgs/ghcup {};

  rmview = self.libsForQt5.callPackage ../pkgs/rmview {};

  all-hackage-sources =
    let
      hpkgs = self.haskellPackages;
      names = builtins.attrNames hpkgs;
      src = map
        (n: hpkgs.${n}.src or null)
        names;
      src' = builtins.filter (x: ! isNull x) src;
    in map (x: { name = x.name; path = x; }) src';

  ghcWithAllPackages =
    let

      # getDeps = h:
      #   let deps =
      #         if h ? passthru && h.passthru ? getCabalDeps
      #         then h.passthru.getCabalDeps.libraryHaskellDepends
      #         else [];
      #       deps' = __filter (x: x != null) deps;
      #   in map (x: x.pname) deps';

      # getSysDeps = h:
      #   let deps =
      #         if h ? passthru && h.passthru ? getCabalDeps
      #         then h.passthru.getCabalDeps.librarySystemDepends
      #         else [];
      #       deps' = __filter (x: x != null) deps;
      #   in map (x: if x ? pname then x.pname else x.name) deps';

      isAvailable = v: v ? meta
                   && v.meta ? available
                   && v.meta.available;

      isNotBroken = v: v ? meta
                   && v.meta ? broken
                   && ! v.meta.broken;

      # blacklist = [ "Southpaw" "inline-c-win32" "cplex-hs" "hs-mesos" ];

      pred0 = v: isAvailable v && isNotBroken v;

      # pred = v: pred0 v && ! __elem v.pname blacklist;
      pred = v: pred0 v && (__tryEval (toString v)).success;

      all-package-names =
        __attrNames (
          self.lib.filterAttrs
            (_: pred)
            self.haskellPackages);

      result = self.haskellPackages.ghcWithPackages (hp: map (n: hp.${n}) all-package-names);

      drvs = map (n: self.haskellPackages.${n}) all-package-names;

      farm = self.linkFarmFromDrvs "all-ghc-packages-farm" drvs;

    in

      result // { inherit all-package-names; };

 # ghcWithAllPackages-cached =
 #   let
 #     all-package-names = __fromJSON (__readFile ../hackage-mega-list.json);
 #   in
 #     self.haskellPackages.ghcWithPackages (hp: map (n: hp.${n}) all-package-names);

 # hackage-mega-list = __fromJSON (__readFile ../hackage-mega-list.json);

 # hackage-top-packages =  (__fromJSON (__readFile ../hackage-top-packages.json)).result;

 # hackage-top-2000 = __genList (__elemAt self.hackage-top-packages) 2000;
 # hackage-top-200  = __genList (__elemAt self.hackage-top-packages)  200;

 # hackage-mini-mega-2000 = __filter (n: __elem self.haskellPackages.${n}.pname self.hackage-top-2000) hackage-mega-list;
 # hackage-mini-mega-200  = __filter (n: __elem self.haskellPackages.${n}.pname  self.hackage-top-200) hackage-mega-list;

 # ghcWithAllPackages-top-2000 = self.haskellPackages.ghcWithPackages (hp: map (n: hp.${n}) hackage-mini-mega-2000);
 # ghcWithAllPackages-top-200  = self.haskellPackages.ghcWithPackages (hp: map (n: hp.${n})  hackage-mini-mega-200);

  # not working
  sixel-tmux = super.tmux.overrideAttrs (old: rec {

    name = "sixel-tmux-${version}";
    version = "HEAD";

    src = self.fetchFromGitHub {
      owner = "csdvrx";
      repo = "sixel-tmux";
      rev = "bc340a30ecabcf4f05a8201b798422aa89716991";
      sha256 = "sha256-H40Cyw2mYyxLfO6VHwP/iaHKS/m264gFz/DLBgbVXjY=";
    };

    patchPhase = ''
      substituteInPlace ./Makefile.am --replace " -O2" " -O2 -lm"
      substituteInPlace ./tmux.c --replace " PERMS" " ACCESSPERMS"
    '';

  });

  farbfeld-utils = let
    farbfeld-utils-nix = {stdenv, fetchzip, xorg, SDL, ghostscript, sqlite}:
      stdenv.mkDerivation {
        name = "farbfeld";

        src = fetchzip {
          url = "http://zzo38computer.org/prog/farbfeld.zip";
          sha256 = "sha256-I1o94L2up9eByH38aCW756sSzPrPhnGFDeOOQmPu/cU=";
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
          --replace sqlite3.o ${sqlite.out}/lib/libsqlite3.so \
          --replace /usr/lib/libgs.so.9 ${ghostscript}/lib/libgs.so

        gcc -c ./lodepng.c

        source ./build.sh

      '';

        installPhase = ''
        mkdir -p $out/bin
        cp ./bin/* $out/bin
      '';
      };
  in self.callPackage farbfeld-utils-nix {};

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

  st-flexipatch = self.callPackage ../pkgs/st-flexipatch {};

  myEmacs = self.emacsWithPackages (epkg: with epkg; [ emacs-libvterm ]);

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
