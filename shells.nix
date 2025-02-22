{ nixpkgs, pkgs, ... }:
with pkgs;
rec {
  shell = mkShell {
    buildInputs = [
      pandoc
      texlive.combined.scheme-full
    ];
  };
  default = shell;
}
