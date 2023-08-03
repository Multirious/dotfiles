echo "Rust cross-compilation from Linux to Windows"
sudo apt-get -qq install mingw-w64
rustup target add x86_64-pc-windows-gnu
