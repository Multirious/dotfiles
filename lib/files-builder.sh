export PATH="$coreutils/bin"

mkdir $out
touch $out/names

echo "$linkNixed" >> $out/link-nixed.sh
chmod +x $out/link-nixed.sh

IFS=$'\n'
for kv in $paths; do
    name="${kv%%=*}"
    source="${kv#*=}"
    if [[ ! -d "$(dirname "$name")" ]]; then
        mkdir -p "$out/$(dirname "$name")"
    fi
    ln -s $source $out/$name
    echo "$name" >> $out/names
done
