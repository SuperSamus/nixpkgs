{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.dublin-traceroute;

in
{
  meta.maintainers = pkgs.dublin-traceroute.meta.maintainers;

  options = {
    programs.dublin-traceroute = {
      enable = lib.mkEnableOption "dublin-traceroute (including setcap wrapper)";

      package = lib.mkPackageOption pkgs "dublin-traceroute" { };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    security.wrappers.dublin-traceroute = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_raw+p";
      source = lib.getExe cfg.package;
    };
  };
}
