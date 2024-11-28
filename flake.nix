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
        nixpkgs-24-05 = import inputs.nixpkgs-24-05 nixpkgsArgs;
      in
      rec {
        packages = {
          nodejs = nixpkgs-24-05.nodejs_22;
          pnpm = nixpkgs-24-05.pnpm;
          typescript = nixpkgs-24-05.typescript;
        };
        devShells.default = nixpkgs-24-05.mkShell {
          name = "nix-docker-experiment";
          buildInputs = with packages; [
            nodejs
            pnpm
            typescript
          ];
        };
      }
    );
}
