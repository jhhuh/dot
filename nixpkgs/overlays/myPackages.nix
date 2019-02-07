self: super: rec {

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
