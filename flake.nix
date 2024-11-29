{
  inputs = {
    nixpkgs-24-05.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        nixpkgsArgs = {
          inherit system;
          config = { };
        };
        pkgs = import inputs.nixpkgs-24-05 nixpkgsArgs;
        nodejs = pkgs.nodejs_22;
        pnpm = pkgs.pnpm_9;
        typescript = pkgs.typescript;

        bin = pkgs.stdenv.mkDerivation (finalAttrs: rec {
          pname = "nix-docker-experiment";
          version = "0.0.0";
          src = ./.;
          nativeBuildInputs = [
            nodejs
            pnpm.configHook
          ];
          buildPhase = ''pnpm build'';
          installPhase = ''
            mkdir -p $out/bin
            cp -r ./build/* $out/bin
          '';
          pnpmDeps = pnpm.fetchDeps {
            inherit pname version src;
            hash = "sha256-3VpHNvu2N4gGmO+LtfNVOx1q1CZ/f4fGdOH8+PDi9U8=";
          };
        });

      in
      # dockerImage = pkgs.dockerTools.buildImage {
      #   name = "nix-docker-experiment";
      #   tag = "latest";
      #   copyToRoot = [ bin ];
      #   config = {
      #     Cmd = [ "${bin}/bin/nix-docker-experiment" ];
      #   };
      # };
      {
        packages = {
          default = bin;
        };

        devShells.default = pkgs.mkShell {
          name = "nix-docker-experiment";
          buildInputs = [
            nodejs
            pnpm
            typescript
          ];
        };
      }
    );
}
