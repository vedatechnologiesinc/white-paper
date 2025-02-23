{ nixpkgs, pkgs, ... }:
with pkgs;
rec {
  shell = mkShell {
    buildInputs = [
      emacs
      gnused
      texlive.combined.scheme-full
    ];
  };
  default = shell;
}
