# TODO: add structlint
{ pkgs, pythonMinorVersion }:
let
  lib = pkgs.lib;

  python = pkgs.python3${pythonMinorVersion};

  pythonPackages = pkgs.python3${pythonMinorVersion}Packages;

  pythonMkdocs = python.withPackages (
    p:
    (with p; [
      mkdocs
      mkdocstrings
      mkdocstrings-python
      mkdocs-material
      pygments
    ])
  );

  # TODO: package mdsf if version on nixpkgs is not bumped soon, or make PR to nixpkgs

  pythonMdformat = python.withPackages (p: [
    p.mdformat
    p.mdformat-mkdocs
  ]);
in
{
  mkdocs-with-plugins = pkgs.writeShellScriptBin "mkdocs" ''
    exec ${pythonMkdocs}/bin/mkdocs "$@"
  '';

  mdformat-with-plugins = pkgs.writeShellScriptBin "mdformat" ''
    ${pythonMdformat}/bin/python -m mdformat --extensions mdformat_mkdocs "$@"
  '';

  justfmt = pkgs.writers.writeBashBin "justfmt" ../codeqa/scripts/justfmt.sh;
}