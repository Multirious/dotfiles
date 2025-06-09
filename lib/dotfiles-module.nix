{ lib, ... }:
{
  options = {
    files = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
    };
  };
}
