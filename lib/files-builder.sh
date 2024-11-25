export PATH="$coreutils/bin"

mkdir $out
mkdir $out/.config

IFS=:
for kv in $paths; do
    name="${kv%%=*}"
    source="${kv#*=}"
    ln -s $source $out/$name
done
