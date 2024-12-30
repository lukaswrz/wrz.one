{
  fetchzip,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "league-spartan";
  version = "2.220";

  src = fetchzip {
    url = "https://github.com/theleagueof/league-spartan/releases/download/${finalAttrs.version}/LeagueSpartan-${finalAttrs.version}.tar.xz";
    hash = "sha256-dkvWRYli8vk+E0DkZ2NWCJKfSfdo4jEcGo0puQpFVVc=";
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/woff2 $src/static/WOFF2/*.woff2

    runHook postInstall
  '';
})
