let

  key-owner = "jhhuh";

  common-spec =  {
    system = "x86_64-linux";
    sshUser = "builder";
    sshKey = "/home/${key-owner}/.ssh/id_ed25519";
    maxJobs = 30;
    speedFactor = 10;
    supportedFeatures = [ "big-parallel" ];
  };

in

  {

    cafe = common-spec // {
      hostName = "cafe.coati-bebop.ts.net";
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUtnYXlTakVLaDBjUTNVdlR3WVFzZ3E0Wm1OTFcwdXU2R2RmTDZhMWxYTW8gcm9vdEBjb21tb24K";
      protocol = "ssh-ng";
    };

    # mimir = common-spec // {
    #   hostName = "mimir.coati-bebop.ts.net";
    #   publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUdDbXFITlVmOFd4OGd5blk4MzJBZTc2QjNuWFhOS2RvZ2N5L2c4SkZDRWMgcm9vdEBtaW1pcgo=";
    #   protocol = "ssh-ng";
    # };

  }
