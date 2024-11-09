{}:
{
  editor = /* toml */''
    theme = "catppuccin_mocha"

    [editor]
    line-number = "relative"
    mouse = false
    scrolloff = 8
    cursorline = true
    idle-timeout = 0
    completion-trigger-len = 0
    rulers = [80, 120]
    color-modes = true
    true-color = true
    popup-border = "all"
    jump-label-alphabet = "fjdkrueivmchgytnbslwoxaqpz"

    [editor.search]
    smart-case = false

    [editor.cursor-shape]
    insert = "bar"
    normal = "block"
    select = "block"

    [editor.file-picker]
    hidden = false

    [editor.whitespace.render]
    space = "none"
    tab = "all"
    newline = "all"

    [editor.whitespace.characters]
    nbsp = "⍽"
    tab = "→"
    newline = "⏎"

    [editor.indent-guides]
    render = true
    character = "╎"

    [keys.insert]
    j.k = "normal_mode"

    # my special keybinds pack
    [keys.normal."+"]
    l = ":lsp-restart"

    [keys.normal.space]
    f = "file_picker_in_current_directory"
    "S-f" = "file_picker"
  '';
  languages = /* toml */ ''
    [language-server.rust-analyzer]
    timeout = 600

    [language-server.rust-analyzer.config]
    cargo.extraEnv.CARGO_TARGET_DIR = "/home/peach/cargo_builds" 
    checkOnSave.command = "clippy" 

    [language-server.godot]
    command = "ncat.exe"
    args = ["127.0.0.1", "6005"]

    [language-server.arduino-language-server]
    command = "arduino-language-server"

    [language-server.ra-multiplex]
    command = "ra-multiplex"
    args = ["client", "--server-path", "/home/peach/.cargo/bin/rust-analyzer"]

    [language-server.ra-multiplex.config]
    cargo.extraEnv.CARGO_TARGET_DIR = "/home/peach/cargo_builds" 
    checkOnSave.command = "clippy" 

    [[language]]
    name = "rust"
    language-servers = ["rust-analyzer"]

    # [language.debugger]
    # command = "codelldb"
    # name = "codelldb"
    # port-arg = "--port {}"
    # transport = "tcp"

    # [[language.debugger.templates]]
    # name = "binary"
    # request = "launch"

    # [[language.debugger.templates.completion]]
    # completion = "filename"
    # name = "binary"

    # [language.debugger.templates.args]
    # program = "{0}"
    # runInTerminal = true

    [[language]]
    name = "gdscript"
    language-servers = ["godot"]

    [[language]]
    name = "arduino"
    scope = "source.arduino"
    injection-regex = "arduino"
    file-types = ["ino", "cpp", "h"]
    comment-token = "//"
    roots = ["sketch.yaml"]
    language-servers = ["arduino-language-server"]
    indent = { tab-width = 4, unit = "    " }
    auto-format = true

    [language.formatter]
    command = "clang-format"

    [[language]]
    name = "lua"
    indent = { tab-width = 4, unit = "    " }

    [[language]]
    name = "c"
    indent = { tab-width = 4, unit = "    " }

    [[language]]
    name = "bash"
    file-types = [
      "sh",
      "bash",
      "ash",
      "dash",
      "ksh",
      "mksh",
      "zsh",
      "zshenv",
      "zlogin",
      "zlogout",
      "zprofile",
      "zshrc",
      "eclass",
      "ebuild",
      "bazelrc",
      "Renviron",
      "zsh-theme",
      "cshrc",
      "tcshrc",
      "bashrc_Apple_Terminal",
      "zshrc_Apple_Terminal",
      { glob = "i3/config" },
      { glob = "sway/config" },
      { glob = "tmux.conf" },
      { glob = ".bash_history" },
      { glob = ".bash_login" },
      { glob = ".bash_logout" },
      { glob = ".bash_profile" },
      { glob = ".bashrc" },
      { glob = ".profile" },
      { glob = ".zshenv" },
      { glob = ".zlogin" },
      { glob = ".zlogout" },
      { glob = ".zprofile" },
      { glob = ".zshrc" },
      { glob = ".zimrc" },
      { glob = "APKBUILD" },
      { glob = ".bash_aliases" },
      { glob = ".Renviron" },
      { glob = ".xprofile" },
      { glob = ".xsession" },
      { glob = ".xsessionrc" },
      { glob = ".yashrc" },
      { glob = ".yash_profile" },
      { glob = ".hushlogin" },

      { glob = "bash/env" },
      { glob = "bash/interactive" },
      { glob = "bash/login" },
      { glob = "bash/logout" },
      { glob = "sh/env" },
      { glob = "sh/login" },
      { glob = "sh/interactive" },
      { glob = "shell/env" },
      { glob = "shell/env_functions" },
      { glob = "shell/interactive" },
      { glob = "shell/login" },
      { glob = "shell/logout" },
      { glob = "zsh/env" },
      { glob = "zsh/interactive" },
      { glob = "zsh/login" },
      { glob = "zsh/logout" },
    ]

    [[grammar]]
    name = "cpp"
    source = { git = "https://github.com/tree-sitter/tree-sitter-cpp", rev = "a90f170f92d5d70e7c2d4183c146e61ba5f3a457" }

    [[grammar]]
    name = "arduino"
    source = { git = "https://github.com/ObserverOfTime/tree-sitter-arduino", rev = "db929fc6822b9b9e1211678d508f187894ce0345" }
  '';
}
