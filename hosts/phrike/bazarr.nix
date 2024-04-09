{ ... }:

{
  services.bazarr = {
    enable = true;
    openFirewall = true;
    group = "wheel";
    user = "steixeira";
  };
}
