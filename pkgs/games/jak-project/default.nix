{ lib
, cmake
, nasm
, stdenv
, fetchFromGitHub

, libpulseaudio
, libX11
, libXcursor
, libXext
, libXi
, libXinerama
, libXrandr
, python3
, rapidjson
}:

stdenv.mkDerivation rec {
  pname = "jak-project";
  version = "0.1.20";

  src = fetchFromGitHub {
    owner = "open-goal";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HW5DZmYU9LlOvI6zpeMESeGHoO8RmziyIroy9vQJR7I=";
  };

  nativeBuildInputs = [ cmake nasm ];

  buildInputs = [
    libpulseaudio
    libX11
    libXcursor
    libXext
    libXi
    libXinerama
    libXrandr
    python3
    rapidjson
  ];

  postInstall = ''
    cp $BIN_SOURCE/game/gk $DEST
    cp $BIN_SOURCE/goalc/goalc $DEST
    cp $BIN_SOURCE/decompiler/extractor $DEST

    strip $DEST/gk
    strip $DEST/goalc
    strip $DEST/extractor

    mkdir -p $DEST/data
    mkdir -p $DEST/data/launcher/
    mkdir -p $DEST/data/decompiler/
    mkdir -p $DEST/data/assets
    mkdir -p $DEST/data/game
    mkdir -p $DEST/data/log
    mkdir -p $DEST/data/game/graphics/opengl_renderer/

    cp -r $SOURCE/.github/scripts/releases/error-code-metadata.json $DEST/data/launcher/error-code-metadata.json
    cp -r $SOURCE/decompiler/config $DEST/data/decompiler/
    cp -r $SOURCE/goal_src $DEST/data
    cp -r $SOURCE/game/assets $DEST/data/game/
    cp -r $SOURCE/game/graphics/opengl_renderer/shaders $DEST/data/game/graphics/opengl_renderer
    cp -r $SOURCE/custom_levels $DEST/data
  '';

  meta = with lib; {
    description = "Reviving the language that brought us the Jak & Daxter Series";
    homepage = "https://github.com/open-goal/jak-project";
    license = licenses.isc;
    maintainers = with maintainers; [ martfont ];
  };
}
