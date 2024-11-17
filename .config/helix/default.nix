{ mkConfig, pkgs, dontPatch ? false }:
mkConfig {
  name = "dotconfig-helix";
  files = {
    "config.toml" = ./config.toml;
    "languages.toml" = ./languages.toml;
  };
}
