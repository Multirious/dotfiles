{
  fetchurl,
  lib,
  stdenv,
  dpkg,
  alsa-lib,
  xorg,
  freetype,
  curl,
  glibc,
  zenity,
  makeBinaryWrapper,
}:
let
  curlGnu = (curl.overrideAttrs
    (final: prev: {
      postPatch = ''
        ${prev.postPatch}

        # The package requires curl with the version symbol `CURL_GNUTLS_3` because 
        # of a curl in debian for whatever reason.
        substituteInPlace ./lib/libcurl.vers.in \
          --replace \
            "CURL_@CURL_LIBCURL_VERSIONED_SYMBOLS_PREFIX@@CURL_LIBCURL_VERSIONED_SYMBOLS_SONAME@" \
            "CURL_@CURL_LIBCURL_VERSIONED_SYMBOLS_PREFIX@3"
      '';
    })).override {
      gnutlsSupport = true;
      opensslSupport = false;
    };
  rpath = lib.makeLibraryPath [
    alsa-lib
    xorg.libX11
    xorg.libXext
    freetype
    (lib.getLib curlGnu)
    stdenv.cc.cc.lib
  ]; 
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sitala";
  version = "1.0.0";
  src = fetchurl {
    url = "https://decomposer.de/sitala/releases/sitala-1.0_amd64.deb";
    hash = "sha256-21BIJm8ZdGyHOxR65PAIjUkHUHSbq/3xS89ArbUc4zM=";
  };
  buildInputs = [
    alsa-lib
    xorg.libX11
    xorg.libXext
    freetype
    curlGnu
    zenity
  ];
  nativeBuildInputs = [
    dpkg
    makeBinaryWrapper
  ];
  unpackPhase = ''
    mkdir -p $out/package
    dpkg -x $src $out/package
  '';
  installPhase = ''
    mkdir -p $out/{bin,lib/vst,share}
    cp $out/package/usr/bin/sitala $out/bin/sitala
    cp $out/package/usr/lib/lxvst/libsitala.so $out/lib/vst/libsitala.so
    chmod +x $out/lib/vst/libsitala.so
    cp -r $out/package/usr/share/ $out
    rm -r $out/package
  '';
  postFixup = ''
    patchelf --set-interpreter ${glibc}/lib/ld-linux-x86-64.so.2 "$out/bin/sitala"
    patchelf --set-rpath ${rpath} "$out/bin/sitala"
    patchelf --set-rpath ${rpath} "$out/lib/vst/libsitala.so"
    wrapProgram "$out/bin/sitala" \
      --prefix PATH : "${
        lib.makeBinPath [
          zenity
        ]
      }"
  '';
  meta = {
    description = "Sitala is a drum plugin and standalone app";
    homepage = "https://decomposer.de/sitala";
    downloadPage = "https://decomposer.de/sitala/#downloads";
    platforms = [ "x86_64-linux" ];
    mainProgram = "sitala";
  };
})

