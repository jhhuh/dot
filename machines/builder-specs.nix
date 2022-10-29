let

  key-owner = "jhhuh";

  common-spec =  {
    system = "x86_64-linux";
    sshUser = "builder";
    sshKey = "/home/${key-owner}/.ssh/id_ed25519";
    maxJobs = 30;
    speedFactor = 10;
  };

in

  {

    mimir = common-spec // {
      hostName = "mimir.coati-bebop.ts.net";
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUdDbXFITlVmOFd4OGd5blk4MzJBZTc2QjNuWFhOS2RvZ2N5L2c4SkZDRWMgcm9vdEBtaW1pcgo=";
    };

  }
