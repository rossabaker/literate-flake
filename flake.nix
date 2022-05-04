{
  description = "A very basic flake";

  inputs.home-manager.url = github:nix-community/home-manager;

  outputs = { self, nixpkgs, home-manager }:
    let
      tangle = pkgs: pkgs.stdenv.mkDerivation {
        name = "nix-config";
        src = ./.;
        buildInputs = [
          pkgs.emacs
        ];
        buildPhase = ''
          ${pkgs.emacs}/bin/emacs -Q -nw config.org --batch -f org-babel-tangle --kill
        '';
        installPhase = ''
          ls -R
          mkdir $out
          install *.nix $out
        '';
      };
      pkgs = nixpkgs.legacyPackages.x86_64-darwin;

      website = pkgs.stdenv.mkDerivation {
        name = "website";
        srcs = ./.;
        buildInputs = [
          pkgs.emacs
        ];
        buildPhase = ''
          export HOME=$TMPDIR
          ${pkgs.emacs}/bin/emacs -Q --script publish.el $HOME/html
          ls -R
        '';
        installPhase = ''
          mkdir $out
          cp -r $HOME/html/. $out
        '';
      };

    in
      (import (tangle pkgs)) { inherit pkgs home-manager; } //
      {
        packages.x86_64-darwin.website = website;
      };
}
