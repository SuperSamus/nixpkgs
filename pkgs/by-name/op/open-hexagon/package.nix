{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, cmake
, copyDesktopItems
, makeDesktopItem
, git
, imgui
, imgui-sfml
, libsodium
, luajit
, pkg-config
, sfml
, zlib
}:

let
  find-libsodium = fetchurl {
    url = "https://raw.githubusercontent.com/facebookincubator/fizz/20ff479c58e59e6d8d17ed1d9acbb71ac01a05ae/build/fbcode_builder/CMake/FindSodium.cmake";
    hash = "sha256-2He/ovo0tvADUlMKPuiALiz42Vx6oIwZkNkxvDbvDm0=";
  };
  boostpfr = fetchFromGitHub {
    owner = "boostorg";
    repo = "pfr";
    rev = "2.2.0";
    sha256 = "sha256-YpKObkuJMjTQEUPIerRvVfdPxy6fl9Om33hpROm1rjw=";
  };
in
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

  nativeBuildInputs = [ cmake copyDesktopItems git pkg-config ];

  buildInputs = [
    imgui
    imgui-sfml
    libsodium
    luajit
    sfml
    zlib
  ];

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
    cp -f ${./CMakeLists.txt} ./CMakeLists.txt
    install -Dm644 ${find-libsodium} ./cmake/Findsodium.cmake
  '';

  cmakeFlags = [
    "-Dimgui_SOURCE_DIR=${imgui.src}"
    "-Dboostpfr_SOURCE_DIR=${boostpfr}"
  ];

  meta = with lib; {
    description = "FOSS clone of Super Hexagon.";
    homepage = "https://openhexagon.org/";
    license = licenses.afl3;
    maintainers = with maintainers; [  ];
  };
}
