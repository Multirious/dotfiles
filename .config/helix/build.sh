export PATH="$coreutils/bin"

mkdir $out
echo "$config_editor" > $out/config.toml
echo "$config_languages" > $out/languages.toml
