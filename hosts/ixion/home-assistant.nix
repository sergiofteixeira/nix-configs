{ ... }:

{
  services.home-assistant = {
    enable = true;
    openFirewall = true;
    extraComponents = [
      "apple_tv"
      "ipma"
    ];
    config = {
      default_config = { };
      http = {
        server_host = "0.0.0.0";
        trusted_proxies = [ "127.0.0.1" ];
        use_x_forwarded_for = true;
      };
    };
  };
}
