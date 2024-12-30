{pkgs, ...}: {
  packages = [
    pkgs.miniserve
    pkgs.rsync
  ];

  processes.miniserve.exec = ''
    miniserve public --port 8080 --index index.html
  '';

  scripts = {
    publish.exec = ''
      rsync \
        --recursive \
        --delete \
        --update \
        --mkpath \
        --verbose --verbose \
        public/ lukas@wrz.one:/var/www/wrz.one
    '';

    getfonts.exec = let
      league-spartan = pkgs.callPackage ./league-spartan.nix {};
    in ''
      rsync \
        --recursive \
        --delete \
        --update \
        --mkpath \
        --verbose --verbose \
        --include='*/' --include='*.woff2' --exclude='*' \
        ${league-spartan}/share/fonts/woff2/ public/static/fonts/league-spartan
    '';
  };

  pre-commit.hooks = {
    # Nix
    alejandra.enable = true;
    deadnix.enable = true;
    statix.enable = true;
  };
}
