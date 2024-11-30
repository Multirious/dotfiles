# Multirious's insane dotfiles repository
My massive Nix-based dotfiles repository with too much configuration but I like it.

To link without Nix, run:
```bash
./cached/link_cached
```
The `cached` directory contains the built Nix derivation with all symbolic links from /nix/store resolved and copied including plugins.
This creates a standalone dotfiles collection without any required dependecy, not even plugin managers. Pretty cool!

If Nix is installed, run:
```bash
./link.sh
```
Packages, applications, and fonts are then can be installed using home-manager.
