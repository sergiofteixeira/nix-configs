{ ... }:
{

  services.openbao = {
    enable = true;

    settings = {
      ui = true;

      listener.default = {
        type = "tcp";
        address = "127.0.0.1:8200";
        tls_disable = true;
      };

      api_addr = "http://127.0.0.1:8200";
      cluster_addr = "http://localhost:8201";

      storage = {
        raft = {
          path = "/var/lib/openbao";
        };
      };
    };
  };

}
