self: super: rec {
  nbstripout = self.callPackages ../nbstripout {};

  vimb-unwrapped = self.callPackages ../vimb {};

  webkitgtk = self.callPackages ../webkitgtk (with self; {
    harfbuzz = harfbuzzFull;
    inherit (gst_all_1) gst-plugins-base gst-plugins-bad;
    stdenv = overrideCC stdenv gcc6;
    gobject-introspection = gobjectIntrospection;
    gtk2 = self.gtk2;
    enableGtk2Plugins = true;
  });

#  st = let
#    st-ime = self.fetchurl {
#      url = "https://st.suckless.org/patches/fix_ime/st-ime-20190202-3be4cf1.diff";
#      sha256 = "0n4sq5xjx5shkdwv9hfwzjpiknra3076m8k1aimsjfqyw6gklnng";
#    };
#      in
#    super.st.override { patches = [ st-ime ]; };

  st = let
     version = "0.8.2-3";
     name = "st-${version}";
     src = self.fetchurl {
       url = "https://github.com/odknt/st/archive/${version}.tar.gz";
       sha256 = "0s0q6qa53llpazzrvvnnfqcc0kv6akhvc8v9ppk38rkzmyjd9avy";
     };
   in super.st.overrideDerivation (attr: { inherit version name src; });

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
  
  brainworkshop = self.callPackage ../brainworkshop {};
  
  ataripp = self.callPackage ../atari++ {};
  
  BlueALSA = self.callPackage ../BlueALSA {};

}
