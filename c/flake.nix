{
  description = "A Nix-flake-based C development environment";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f: nixpkgs.lib.genAttrs supportedSystems (system: f { pkgs = import nixpkgs { inherit system; }; });
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              subunit
              cppcheck
              lldb
              lcov
              check
              libgcc
              gcc13
              llvmPackages_18.clang-unwrapped
              llvmPackages_18.clang-manpages
              man-pages-posix
            ];
          };
        }
      );
    };
}
