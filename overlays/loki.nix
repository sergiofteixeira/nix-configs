self: super:

let
  fetchFromGitHub = super.fetchFromGitHub;
  buildGoModule = super.buildGoModule;
in
{
  grafana-loki = buildGoModule rec {
    pname = "grafana-loki";
    version = "unstable-$(builtins.currentTime)";

    src = fetchFromGitHub {
      owner = "grafana";
      repo = "loki";
      rev = "main";
      sha256 = "sha256-8R4ZJVaavZRiouk0G82QCHfSqcmTWVQqp3lj2vxH1HA=";
      fetchSubmodules = true;
    };

    vendorSha256 = "sha256-Yb5WaN0abPLZ4mPnuJGZoj6EMfoZjaZZ0f344KWva3o=";

    subPackages = [
      "cmd/loki"
      "cmd/promtail"
      "cmd/logcli"
    ];

    meta = with super.lib; {
      description = "Grafana Loki: like Prometheus, but for logs";
      homepage = "https://grafana.com/oss/loki/";
      license = licenses.asl20;
    };
  };
}
