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

  cafe = common-spec // {
    hostName = "cafe.coati-bebop.ts.net";
    publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUtnYXlTakVLaDBjUTNVdlR3WVFzZ3E0Wm1OTFcwdXU2R2RmTDZhMWxYTW8gcm9vdEBjb21tb24K";
    protocol = "ssh-ng";
  };
} //
__mapAttrs (n: v: common-spec // {
  hostName = n;
  publicHostKey = v;
  protocol = "ssh-ng";
  supportedFeatures = [ "big-parallel" "gccarch-znver4" ];
} )
  {
    #tera001 = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUxJYW93YkI4clF2dTBNc1dXRVlUb1B3VmdwTnU4VHVXYjlFYTI1cVF2cTQgcm9vdEBtZWdhMDAwCg==";
    #tera002 = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUVCQWNzNHpyWk5BeiszMWx6Y3dvQ0NkOGt6TE5hU01UZVhxd3krTkVJR1Ugcm9vdEBtZWdhMDAwCg==";
    #tera003 = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUxLaENFeEtJeGprT1dBZ3NSenFrS0ZUVWt2cnQrWWZBNnhGWndPVkc0RTAgcm9vdEBtZWdhMDAwCg==";
    #tera004 = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUtZUFU0anNsaXY2SUFoZGszRjBTNi9NTDFOTUdxSEFLKzlxVk9Gc3h5MGIgcm9vdEBtZWdhMDAwCg==";
    # tera005 = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSURqVGNYeDJjYVRMbWROYWlXcld0MWhkS3YrdGZ2eTFkKzBKT011cXZDNUEgcm9vdEBtZWdhMDAwCg==";
    # tera006 = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSU5KL0xJSlRWbEYwZ0d3UmQ0K0lEM2I2dmFrMm51UE9FZ0VGMTZGS0tmWGggcm9vdEBtZWdhMDAwCg==";
    # tera007 = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUF1TXFHeFZjOE9iS1QxM1hiV1VXYzNWUUF0RGZ3TVluUDRtSllrMGJzS0cgcm9vdEBtZWdhMDAwCg==";
    # tera008 = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUU1MHdWbS9yKzM5czBKOG1mYThXVVFTTTBCYmJyL2JDdU40M09vbUxkSGUgcm9vdEBtZWdhMDAwCg==";
    # tera009 = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSU9MRi9qRmFRL2RTMnpLbC92dU1kQnlINkpiT2dLT2MvRThqLzJqaHowMTMgcm9vdEBtZWdhMDAwCg==";
    # tera010 = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpNSkt6WlBzeVdFZEEvVGFWMEhiWlgwTUI5TUtKc0lsTHFNQlp4MTM4NG4gcm9vdEBtZWdhMDAwCg==";
  }


  # mimir = common-spec // {
  #   hostName = "mimir.coati-bebop.ts.net";
  #   publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUdDbXFITlVmOFd4OGd5blk4MzJBZTc2QjNuWFhOS2RvZ2N5L2c4SkZDRWMgcm9vdEBtaW1pcgo=";
  #   protocol = "ssh-ng";
  # };
