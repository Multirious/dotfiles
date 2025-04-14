{ pkgs, ... }:
{
  gtk.enable = true;
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.posy-cursors;
    name = "Posy_Cursor";
    size = 16;
  };
}
