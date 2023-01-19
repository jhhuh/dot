{ config, lib, pkgs, ... }:

{

  services.grafana.enable = true;
  services.grafana.settings = {
    "grafana-cafe" = {};
  };

  services.prometheus = {
    enable = true;
    scrapeConfigs = [
      {
        job_name = "cafe";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }];
  };

  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" "btrfs" ];
  };
}
