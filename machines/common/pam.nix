{ config, lib, ... }:
{
  security.pam.enableSSHAgentAuth = true;
}
