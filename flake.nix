{
  description = "helveticanonstandard.net";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      hooks,
      treefmt,
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        hooks.flakeModule
        treefmt.flakeModule
      ];

      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem =
        {
          config,
          pkgs,
          self',
          ...
        }:
        {
          treefmt = {
            projectRootFile = "flake.nix";

            programs = {
              nixfmt = {
                enable = true;
                package = pkgs.nixfmt-rfc-style;
              };

              prettier = {
                enable = true;
                includes = [ "*.{css,html,js,json,jsx,md,mdx,css,scss,ts,yaml}" ];
              };
            };
          };

          pre-commit.settings.hooks = {
            treefmt.enable = true;
          };

          devShells.default = pkgs.mkShellNoCC {
            packages = [
              pkgs.just
              pkgs.rsync
              pkgs.miniserve
            ];

            env.FONT_LEAGUE_SPARTAN = "${self'.packages.league-spartan}/share/fonts/woff2";

            shellHook = ''
              ${config.pre-commit.installationScript}

              just assets
            '';
          };

          packages = {
            league-spartan = pkgs.callPackage ./league-spartan.nix { };
            libertinus = pkgs.callPackage ./libertinus.nix { };
          };
        };
    };
}
