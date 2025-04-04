{ writeScript, callPackage }:
{
  files = {
    ".zshenv" = ./zshenv;
    ".zshrc" = ./zshrc;
    ".zprofile" = ./zprofile;
    ".config/zsh/env" = ./env;
    ".config/zsh/login" = ./login;
    ".config/zsh/logout" = ./logout;
    ".config/zsh/interactive" = ./interactive;
    ".config/zsh/completion.zsh" = ./completion.zsh;
    ".config/zsh/plugins.zsh" = writeScript "zsh-plugins" (callPackage ./plugins.nix {});
  };
}
