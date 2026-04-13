{
  pkgs,
  pythonMinorVersion,
}: let
  # COMMON ====================================================================
  inherit
    (import ./variables-and-helpers.nix {inherit pkgs pythonMinorVersion;})
    cliViaNix
    commonEnv
    commonVars
    dependencies
    dependencyGroups
    fhsSetupPoetry
    fhsSetupUv
    fhsShellHook
    fhsSystemPackages
    fhsVars
    getPythonExecutable
    macSoftware
    packageExecutableName
    packageNameNix
    packageNamePython
    pkgEnvName
    pureShellHook
    pureVars
    python
    pythonPackages
    sourcePreference
    universalHook
    writeVars
    ;

  inherit (pkgs) lib;

  envName = "py3.${pythonMinorVersion}";

  fhsDependencies =
    (
      if cliViaNix
      then dependencies.flex
      else []
    )
    ++ dependencies.nonPython ++ fhsSystemPackages;
  # # UV2NIX ====================================================================
  # workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ../.; };
  # pyprojectOverlay = workspace.mkPyprojectOverlay { sourcePreference = "wheel"; };
  # pyprojectOverrides = _final: _prev: { };
  # pythonSet = (pkgs.callPackage pyproject-nix.build.packages { inherit python; }).overrideScope (
  #   lib.composeManyExtensions [
  #     pyproject-build-systems.overlays.default
  #     pyprojectOverlay
  #     pyprojectOverrides
  #   ]
  # );
  # editablePythonSet = pythonSet.overrideScope (
  #   workspace.mkEditablePyprojectOverlay { root = "$REPO_ROOT"; }
  # );
  # virtualenvForDev = editablePythonSet.mkVirtualEnv envName { ${packageNameNix} = dependencyGroups; };
  # virtualenvForPackage = pythonSet.mkVirtualEnv pkgEnvName workspace.deps.default;
  # pythonExecutableForDev = getPythonExecutable virtualenvForDev;
in {
  # inherit packageNameNix;

  # package = virtualenvForPackage;

  # app = {
  #   type = "app";
  #   program = "${virtualenvForPackage}/bin/${packageExecutableName}";
  # };

  # uvPure = pkgs.mkShell {
  #   packages = [ virtualenvForDev ] ++ dependencies.nonPython ++ dependencies.flex;

  #   env = commonVars // {
  #     UV_NO_SYNC = "1";
  #     UV_PYTHON = pythonExecutableForDev;
  #     UV_PYTHON_DOWNLOADS = "never";
  #     NIX_PYTHON = pythonExecutableForDev;
  #   };

  #   shellHook = universalHook;
  # };

  uvShell = (
    pkgs.mkShell rec {
      name = "${envName}-fhs-uv";
      packages =
        [
          python
          pkgs.uv
        ]
        ++ fhsDependencies;
      profile = ''
        ${universalHook}

        ${writeVars (commonVars // fhsVars)}

        ${fhsSetupUv}

        ${fhsShellHook}
      '';
    }
  );

  uvFHS =
    (pkgs.buildFHSUserEnv rec {
      name = "${envName}-fhs-uv";
      targetPkgs =
        [
          python
          pkgs.uv
        ]
        ++ fhsDependencies;
      profile = ''
        ${universalHook}

        ${writeVars (commonVars // fhsVars)}

        ${fhsSetupUv}

        ${fhsShellHook}
      '';
    }).env;

  # poetryPure = pkgs.mkShell {
  #   shellHook = universalHook;
  #   env = commonVars;
  #   buildInputs =
  #     [python poetryEnvPure]
  #     ++ dependencies.nonPython
  #     ++ dependencies.flex;
  # };

  poetryShell = pkgs.mkShell {
    name = "${envName}-poetry-shell";

    packages =
      [
        python
        pkgs.poetry
        pkgs.git
        pkgs.alejandra
      ]
      ++ (
        if pkgs.system == "aarch64-darwin"
        then macSoftware
        else []
      ); # ++ fhsDependencies;

    shellHook = ''
      ${universalHook}

      ${writeVars (commonVars // fhsVars)}

      #${fhsSetupPoetry}

      ${fhsShellHook}
    '';
  };

  poetryFHS =
    (pkgs.buildFHSUserEnv rec {
      name = "${envName}-fhs-poetry";
      targetPkgs =
        [
          python
          pkgs.poetry
        ]
        ++ fhsDependencies;
      profile = ''
        ${universalHook}

        ${writeVars (commonVars // fhsVars)}

        ${fhsSetupPoetry}

        ${fhsShellHook}
      '';
    }).env;
}
