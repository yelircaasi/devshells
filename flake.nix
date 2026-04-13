{
  description = "Custom ad hoc development environments.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/ed6dfbea24297e3f2e6abd2db6df97aac75652cf"; # Pinned 2025-04-13

  outputs = {self, ...} @ inputs: let
    supportedSystems = [
      "x86_64-linux" # 64-bit Intel/AMD Linux
      "aarch64-linux" # 64-bit ARM Linux
      "aarch64-darwin" # 64-bit ARM macOS
    ];

    pythonMinorVersion = "13";

    forEachSupportedSystem = f:
      inputs.nixpkgs.lib.genAttrs supportedSystems (
        system:
          f {
            inherit system;
            pkgs = import inputs.nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
          }
      );
  in {
    devShells = forEachSupportedSystem (
      {
        pkgs,
        system,
      }: let
        envs = import ./nix/python-environments.nix {inherit pkgs pythonMinorVersion;};
      in rec {
        #
        default = poetry;
        poetry = envs.poetryShell;
        uv = envs.uvShell;
        test = pkgs.mkShellNoCC {
          packages = with pkgs; [
            alejandra
            ponysay
          ];
          env = {};
          shellHook = "";
        };
      }
    );

    customPackages = forEachSupportedSystem (
      {pkgs, ...}: import ./nix/custom-packages.nix {inherit pkgs pythonMinorVersion;}
    );
  };
}
