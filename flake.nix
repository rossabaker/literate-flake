{
  description = "A very basic flake";

  inputs.home-manager.url = github:nix-community/home-manager;

  outputs = { self, nixpkgs, home-manager }@inputs:
    let
      tangle = pkgs: pkgs.stdenv.mkDerivation {
        name = "tangle";
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
          install * $out
        '';
      };
      pkgs = nixpkgs.legacyPackages.x86_64-darwin;
    in
      pkgs.callPackage (import (tangle pkgs)) inputs;
}
