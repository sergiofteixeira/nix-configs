let
  steixeira = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICySDx70VKoXhwoQbGGx1FpZsqWMhJxcOipc76eFztVZ sergio@triggerise.org";
  m1pro = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP3Kyi4yJ9sMHfNrLalUH4m1asVxEaqXnqgX7LP1qz6+";
  ixion = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINl3HnP5ibTK5fGn90C5WJaeMkBQ4CWUSvFFpXKQ34si root@ixion";
in
{
  "cloudflare_token.age".publicKeys = [
    steixeira
    m1pro
    ixion
  ];
  "tailscale_key.age".publicKeys = [
    steixeira
    m1pro
    ixion
  ];
  "tapo_secrets.age".publicKeys = [
    steixeira
    m1pro
    ixion
  ];
  "token.age".publicKeys = [
    steixeira
    ixion
  ];
}
