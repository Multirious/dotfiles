export PATH="$coreutils"
mkdir $out
echo "$config" >> $out/tmux.conf
echo "" >> $out/tmux.conf
echo "$plugins_config" >> $out/tmux.conf
