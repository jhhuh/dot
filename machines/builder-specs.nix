let

  key-owner = "jhhuh";

  common-spec =  {
    system = "x86_64-linux";
    sshUser = "builder";
    sshKey = "/home/${key-owner}/.ssh/id_ed25519";
    maxJobs = 30;
    speedFactor = 10;
    supportedFeatures = [ "big-parallel"];
  };

in

{

  zhao = common-spec // {
    hostName = "zhao.coati-bebop.ts.net";
    publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUVqa08xTFpJaTEyN3drZm16eUMvYWpDTU54TXVUL3ZYclNzWCticUMxT2Igcm9vdEB6aGFvCg==";
    protocol = "ssh-ng";
  };

  # cafe = common-spec // {
  #   hostName = "cafe.coati-bebop.ts.net";
  #   publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUtnYXlTakVLaDBjUTNVdlR3WVFzZ3E0Wm1OTFcwdXU2R2RmTDZhMWxYTW8gcm9vdEBjb21tb24K";
  #   protocol = "ssh-ng";
  # };

} //
__mapAttrs (n: v: common-spec // {
  hostName = n;
  publicHostKey = v;
  protocol = "ssh-ng";
  supportedFeatures = [ "big-parallel" "gccarch-znver4" ];
} )
  {
    # tera010 = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpNSkt6WlBzeVdFZEEvVGFWMEhiWlgwTUI5TUtKc0lsTHFNQlp4MTM4NG4gcm9vdEBtZWdhMDAwCg==";
  }

