{ config, ... }:

{
  services.prometheus = {
    enable = true;
    extraFlags = [
      "--web.enable-remote-write-receiver"
    ];
  };
}
