{
  description = "Polina's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile.
      # To search by name, run: `nix-env -qaP | grep wget`
      environment.systemPackages = with pkgs; [
        git
        p7zip
        ripgrep
        yazi
        ffmpeg-full
        imagemagick
        curl
        wget
        yt-dlp
        hyfetch
        fnm
        zulu17
      ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using: `darwin-rebuild build --flake .#Polinas-MacBook-Pro`
    darwinConfigurations."Polinas-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ./defaults.nix ];
    };
  };
}
