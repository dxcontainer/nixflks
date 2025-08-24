{
  description = "'s6-overlay' CLI for setting up 's6-overlay' files and directories, as well as creating, removing, and linting services.";

  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      supportedSystems = nixpkgs.lib.systems.flakeExposed;

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (system: {
        s6-cli = pkgs.${system}.buildGoModule rec {
          pname = "s6-cli";
          version = "0.2.0";

          src = pkgs.${system}.fetchFromGitHub {
            owner = "dazz";
            repo = "s6-cli";
            tag = "v${version}";

            # To get the source hash, first use a placeholder like `nixpkgs.lib.fakeHash`.
            # The build will fail, and the error message will show the correct hash.
            # ---------------------------------------------------------------------------
            # $ nix build '.#s6-cli'
            # ---------------------------------------------------------------------------
            # hash = nixpkgs.lib.fakeHash;
            hash = "sha256-A4bHOmctWqM1K6AOVznSmqw7f7HoULa8jn93ohdxgJc=";
          };

          # After updating the source `hash`, run the build command again with a fake
          # `vendorHash`. The build will fail a second time, providing the correct
          # hash for the Go module dependencies.
          # ---------------------------------------------------------------------------
          # $ nix build '.#s6-cli'
          # ---------------------------------------------------------------------------
          # vendorHash = nixpkgs.lib.fakeHash;
          vendorHash = "sha256-XjmoKtlcynjSLdikWVGdsn2y3SY3ximWmoe2wEMhfXs=";

          postInstall = ''
            mv $out/bin/s6cli $out/bin/s6-cli
          '';
        };
      });
    };
}
