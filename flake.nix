{
  description = "Nix Flakes Collection for DxContainer";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    bashbrew-flake = {
      url = "./pkgs/bashbrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    s6-cli-flake = {
      url = "./pkgs/s6-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      s6-cli-flake,
      bashbrew-flake,
      ...
    }:
    let
      supportedSystems = nixpkgs.lib.systems.flakeExposed;

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});

      installNixPackages = pkgs: [
        pkgs.nix
        pkgs.busybox
      ];

      installNixProfilePackages = pkgs: [
        pkgs.nixd # Nix Language Server
        pkgs.nixfmt-rfc-style # Nix Formatter
      ];

      installNixShellScripts = pkgs: [
        (pkgs.writeShellScriptBin "log" ''
          # If the third argument is explicitly 'break', print a leading newline.
          # The default is now 'nobreak'.
          if [ "''${3:-nobreak}" = "break" ]; then
            echo
          fi

          # Run the gum log command with the first two arguments.
          ${pkgs.gum}/bin/gum log --level "$1" "$2"

          # If the fourth argument is explicitly 'break', print a trailing newline.
          # The default is now 'nobreak'.
          if [ "''${4:-nobreak}" = "break" ]; then
            echo
          fi
        '')
      ];
    in
    {
      # Run: $ nix develop
      devShells = forAllSystems (system: {
        default = pkgs.${system}.mkShellNoCC {
          packages = (installNixPackages pkgs.${system}) ++ (installNixShellScripts pkgs.${system});
        };
      });

      packages = forAllSystems (system: {
        # Run: $ nix profile install
        default = pkgs.${system}.buildEnv {
          name = "profile";
          paths = (installNixPackages pkgs.${system}) ++ (installNixProfilePackages pkgs.${system});
        };

        # Packages [Flakes]
        bashbrew = bashbrew-flake.packages.${system}.bashbrew;
        s6-cli = s6-cli-flake.packages.${system}.s6-cli;
      });
    };
}
