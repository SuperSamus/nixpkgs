{ lib
, stdenv
, fetchFromGitHub
, cmake
, cpm-cmake
, copyDesktopItems
, makeDesktopItem
, imgui
, imgui-sfml
, luajit
, sfml
, zlib
}:

stdenv.mkDerivation rec {
  pname = "open-hexagon";
  version = "unstable-2023-04-21";

  src = fetchFromGitHub {
    owner = "SuperV1234";
    repo = "SSVOpenHexagon";
    rev = "1e2cba71242ab149d548abdb54d3bceb92c33922";
    fetchSubmodules = true;
    sha256 = "sha256-7H4DmzlByNBI9uke2m01hxPYFootIPwcKl/Iu2VsKyQ=";
  };

  nativeBuildInputs = [ cmake copyDesktopItems ];

  buildInputs = [ ];

  desktopItems = [
    (makeDesktopItem {
      name = "open-hexagon";
      exec = "open-hexagon";
      icon = "open-hexagon";
      desktopName = "Open Hexagon";
      comment = meta.description;
      type = "Application";
      categories = [ "Game" "ArcadeGame" ];
      startupWMClass = "SSVOpenHexagon";
    })
  ];

  preConfigure = ''
    mkdir -p cmake/cpm
    cp ${cpm-cmake}/share/cpm/CPM.cmake cmake/cpm/CPM_0.37.0.cmake
  '';

  cmakeFlags = [
    "-DCPM_SOURCE_CACHE=cmake"
    "-DFETCHCONTENT_SOURCE_DIR_SFML=${sfml}"
    "-DFETCHCONTENT_SOURCE_DIR_LUAJIT=${luajit}"
    "-DFETCHCONTENT_SOURCE_DIR_ZLIB=${zlib}"
    "-DFETCHCONTENT_SOURCE_DIR_IMGUI=${imgui}"
    "-DFETCHCONTENT_SOURCE_DIR_IMGUI-SFML=${imgui-sfml}"
  ];


  meta = with lib; {
    description = "FOSS clone of Super Hexagon.";
    homepage = "https://openhexagon.org/";
    license = licenses.afl3;
    maintainers = with maintainers; [  ];
  };
}