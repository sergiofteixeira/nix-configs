let
  steixeira = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICySDx70VKoXhwoQbGGx1FpZsqWMhJxcOipc76eFztVZ sergio@triggerise.org";
  helios = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILTzly67QHrzaXtxnsc/t6429HR9ba9iDQ12Z3SknpAN root@helios";
  m1pro = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP3Kyi4yJ9sMHfNrLalUH4m1asVxEaqXnqgX7LP1qz6+";
in
{
  "cloudflare_token.age".publicKeys = [
    steixeira
    helios
    m1pro
  ];
  "tailscale_key.age".publicKeys = [
    steixeira
    helios
    m1pro
  ];
  "tapo_secrets.age".publicKeys = [
    steixeira
    helios
    m1pro
  ];
  "token.age".publicKeys = [
    steixeira
    helios
  ];
}
