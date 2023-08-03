# Install rustup unattend
curl https://sh.rustup.rs -sSf | sh -s -- -y

# Additional tools
cargo install cargo-expand

# Cross-compilation from Linux to Windows
sudo apt-get -qq install mingw-w64
rustup target add x86_64-pc-windows-gnu
