self: super: rec {

  vimb-unwrapped = self.callPackages ../vimb {};

  webkitgtk = self.callPackages ../webkitgtk (with self; {
    harfbuzz = harfbuzzFull;
    inherit (gst_all_1) gst-plugins-base gst-plugins-bad;
    stdenv = overrideCC stdenv gcc6;
    gobject-introspection = gobjectIntrospection;
    gtk2 = self.gtk2;
    enableGtk2Plugins = true;
  });

  st_base16 = self.callPackage ../st_base16 {};

  base16-st = self.fetchFromGitHub {
      owner = "honza";
      repo = "base16-st";
      rev = "b3d0d4fbdf86d9b3eda06f42a5bdf261b1f7d1d1";
      sha256 = "1z08abn9g01nnr1v4m4p8gp1j8cwlvcadgpjb7ngjy8ghrk8g0sh";
  };

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
