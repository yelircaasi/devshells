# TODO: add structlint
# TODO: package mdsf if version on nixpkgs is not bumped soon, or make PR to nixpkgs
{
  pkgs,
  pythonMinorVersion,
}: let
  inherit (pkgs) lib stdenv fetchurl unzip autoPatchelfHook;

  platformMap = {
    "x86_64-linux" = {
      arch = "amd64";
      os = "linux";
      ext = "tar.gz";
    };
    "aarch64-linux" = {
      arch = "arm64";
      os = "linux";
      ext = "tar.gz";
    };
    "x86_64-darwin" = {
      arch = "amd64";
      os = "darwin";
      ext = "zip";
    };
    "aarch64-darwin" = {
      arch = "arm64";
      os = "darwin";
      ext = "zip";
    };
  };

  systemParams = platformMap.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  python = pkgs."python3${pythonMinorVersion}";

  pythonPackages = pkgs."python3${pythonMinorVersion}Packages";

  pythonMkdocs = python.withPackages (
    p: (with p; [
      mkdocs
      mkdocstrings
      mkdocstrings-python
      mkdocs-material
      pygments
    ])
  );

  pythonMdformat = python.withPackages (p: [
    p.mdformat
    p.mdformat-mkdocs
  ]);
in {
  mkdocs-with-plugins = pkgs.writeShellScriptBin "mkdocs" ''
    exec ${pythonMkdocs}/bin/mkdocs "$@"
  '';

  mdformat-with-plugins = pkgs.writeShellScriptBin "mdformat" ''
    ${pythonMdformat}/bin/python -m mdformat --extensions mdformat_mkdocs "$@"
  '';

  justfmt = pkgs.writers.writeBashBin "justfmt" ../codeqa/scripts/justfmt.sh;

  azd = lib.optional stdenv.isDarwin (let
    version = "1.23.15";
  in
    stdenv.mkDerivation {
      pname = "azd";
      inherit version;

      src = fetchurl {
        url = "https://azuresdkartifacts.z5.web.core.windows.net/azd/standalone/release/${version}/azd-${systemParams.os}-${systemParams.arch}.${systemParams.ext}";
        hash = "sha256-FqV5wC1qChDiTWqnO8W9FqRezpT6cogQSfCjEBOJj/Y=";
      };

      sourceRoot = ".";

      nativeBuildInputs = [] ++ lib.optional (systemParams.ext == "zip") unzip;

      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall

        mkdir -p $out/bin
        # The archive contains a binary named azd-<os>-<arch>
        cp azd-* $out/bin/azd
        chmod +x $out/bin/azd

        runHook postInstall
      '';

      meta = with lib; {
        description = "Azure Developer CLI";
        homepage = "https://github.com/Azure/azure-dev";
        license = licenses.mit;
        platforms = builtins.attrNames platformMap;
      };
    });
}
