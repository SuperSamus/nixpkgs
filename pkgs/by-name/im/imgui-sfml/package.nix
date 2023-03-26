{ lib
, stdenv
, fetchFromGitHub
, cmake
, imgui
, libGL
, sfml
}:

stdenv.mkDerivation rec {
  pname = "imgui-sfml";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "SFML";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1oXTZ7YhCwz9IjZVwwB0TDJv3Ps2d0ka0zcSO2jDKrI=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ imgui libGL sfml ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=1"
    "-DIMGUI_DIR=${imgui.src}"
  ];

  meta = with lib; {
    description = "Dear ImGui backend for use with SFML";
    homepage = "https://github.com/SFML/imgui-sfml";
    license = licenses.mit;
    maintainers = with maintainers; [  ];
  };
}
