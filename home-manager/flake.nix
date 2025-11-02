{
  description = "Home Manager configuration of peach";

  inputs = {
    system.url = "/etc/nixos/";
    nixpkgs.follows ="system/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    Hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };
    hypr-dynamic-cursors = {
      url = "github:VirtCode/hypr-dynamic-cursors";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = inputs:
  let
    home = system: userModule:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            (import inputs.rust-overlay)
          ];
        };
      in inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          externalPkgs = {
            inherit (inputs) Hyprspace hypr-dynamic-cursors;
            inherit (import ./custom-packages { inherit pkgs; }) sitala;
          };
        };
        modules = [ ./home.nix ./modules userModule ];
      };
  in
  {
    homeConfigurations."peach" = home "x86_64-linux" ./users/peach.nix;
  };
}
