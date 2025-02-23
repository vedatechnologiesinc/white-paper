{ nixpkgs, pkgs, ... }:
with pkgs;
rec {
  shell = mkShell {
    buildInputs = [
      emacs
      texlive.combined.scheme-full
    ];
  };
  default = shell;
}
