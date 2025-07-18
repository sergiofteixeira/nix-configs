{ ... }:
{

  services.glance = {
    enable = true;
  };

  services.duplicati = {
    enable = true;
    parameters = ''
      --webservice-allowedhostnames=*
    '';
  };
}
