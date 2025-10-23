{ ... }:

{
  services.bazarr = {
    enable = true;
    openFirewall = true;
    user = "steixeira";
    group = "media";
  };
}
