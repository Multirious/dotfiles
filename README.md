# My Nix-based dotfiles repository
Dotfiles repository that utilizes Nix for improved
configurability, consistency, and reproducibility.
Caching system to allows working in environment without Nix.
This repository also contains generalized shell configuration
as described by [this blog][1].
Overall, a super portable and flexible config for me.

To link without Nix, run:
```bash
./cached/link_cached
```

If Nix is installed, run:
```bash
./link.sh
```
Packages, applications, and fonts are then can be installed using home-manager.

The files is not managed by home-manager directly but through custom flake-less
Nix rawdogged-derivation and script.
- This allows me to personalize my dotfiles better since packages configurations
  provided by home-manager are quite inconsistant and awkward to use.
  Many packages provides their own configuable options which abstraced over the
  original packages configs and most of the time are scattered and confusing to
  understand. Thus, they forces me to read the package source file anyways, so
  why don't I just script them up my self?
- home-manager is not a requirement if for whatever reasons I didn't install it.
- The configs are built a lot faster than using home-manager.
- I didn't use flake because they are mostly useless in this case and they are
  kinda hard to use.

[1]: https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html
