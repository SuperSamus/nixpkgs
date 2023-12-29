{ lib
, stdenv
, fetchFromGitHub
, cmake
, libX11
, freetype
, libjpeg
, openal
, flac
, libvorbis
, glew
, libXcursor
, libXrandr
, libXrender
, udev
, xcbutilimage
, IOKit
, Foundation
, AppKit
, OpenAL
}:

stdenv.mkDerivation rec {
  pname = "sfml";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "SFML";
    repo = "SFML";
    rev = version;
    sha256 = "sha256-R+ULgaKSPadcPNW4D2/jlxMKHc1L9e4FprgqLRuyZk4=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ freetype libjpeg openal flac libvorbis glew ]
    ++ lib.optional stdenv.isLinux udev
    ++ lib.optionals (!stdenv.isDarwin) [ libX11 libXcursor libXrandr libXrender xcbutilimage ]
    ++ lib.optionals stdenv.isDarwin [ IOKit Foundation AppKit OpenAL ];

  preConfigure = ''
    for file in ./tools/pkg-config/*; do
      substituteInPlace "$file" \
        --replace libdir=\''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@ libdir=@CMAKE_INSTALL_FULL_LIBDIR@
    done
  '';

  cmakeFlags = [
    "-DSFML_INSTALL_PKGCONFIG_FILES=yes"
    "-DSFML_MISC_INSTALL_PREFIX=share/SFML"
    "-DSFML_BUILD_FRAMEWORKS=no"
    "-DSFML_USE_SYSTEM_DEPS=yes"
  ];

  meta = with lib; {
    homepage = "https://www.sfml-dev.org/";
    description = "Simple and fast multimedia library";
    longDescription = ''
      SFML is a simple, fast, cross-platform and object-oriented multimedia API.
      It provides access to windowing, graphics, audio and network.
      It is written in C++, and has bindings for various languages such as C, .Net, Ruby, Python.
    '';
    license = licenses.zlib;
    maintainers = [ maintainers.astsmtl ];
    platforms = platforms.unix;
  };
}
