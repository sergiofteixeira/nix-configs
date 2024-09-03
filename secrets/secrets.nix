let
  steixeira = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICySDx70VKoXhwoQbGGx1FpZsqWMhJxcOipc76eFztVZ sergio@triggerise.org";
  system-phrike = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL8tYvNe+s15uh8Sg03g8cCDCjCtfc/UDeNuWLb7qZ/l root@nixos";
  m1pro = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP3Kyi4yJ9sMHfNrLalUH4m1asVxEaqXnqgX7LP1qz6+";
in
{
  "cloudflare_token.age".publicKeys = [
    steixeira
    system-phrike
    m1pro
  ];
  "anthropic_api_key.age".publicKeys = [
    steixeira
    system-phrike
    m1pro
  ];
  "gemini_api_key.age".publicKeys = [
    steixeira
    system-phrike
    m1pro
  ];
  "tailscale_key.age".publicKeys = [
    steixeira
    system-phrike
    m1pro
  ];
  "vault_token.age".publicKeys = [
    steixeira
    system-phrike
    m1pro
  ];
  "vault_addr.age".publicKeys = [
    steixeira
    system-phrike
    m1pro
  ];
}
