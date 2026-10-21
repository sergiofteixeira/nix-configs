{ ... }:

{
  # Upstream renamed the library tag to dns-server-v<version>, so the nixpkgs
  # URL 404s. Same contents and hash; drop once nixpkgs follows the rename.
  nixpkgs.overlays = [
    (final: prev: {
      technitium-dns-server-library = prev.technitium-dns-server-library.overrideAttrs (old: {
        src = final.fetchzip {
          url = "https://github.com/TechnitiumSoftware/TechnitiumLibrary/archive/refs/tags/dns-server-v${old.version}.tar.gz";
          hash = old.src.outputHash;
        };
      });
    })
  ];

  services.technitium-dns-server = {
    enable = true;
    openFirewall = true;
  };
}
