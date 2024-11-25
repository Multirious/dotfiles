export PATH="$coreutils/bin"

mkdir "$out"

while (( "$#" )); do
    name="$1"
    path="$2"

    [ -d "$out/$(dirname $name)" ] || mkdir -p "$out/$(dirname $name)"
    ln -s "$path" "$out/$name"

    shift 2
done
