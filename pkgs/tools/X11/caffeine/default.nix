{ buildPythonApplication
, fetchPypi
, gobject-introspection
, gtk3
, lib
, libayatana-appindicator
, libnotify
, dbus-python
, gettext
, ewmh
, pygobject3
, setuptools
, wrapGAppsHook
}:

buildPythonApplication rec {
  pname = "caffeine";
  version = "2.9.12";

  src = fetchPypi {
    inherit version;
    pname = "cups-of-caffeine";
    sha256 = "sha256-hO5U6D6AB7SkVbXz5hzpfAMywGT+Wzmr0p+CH51Dj4M=";
  };

  nativeBuildInputs = [ gettext wrapGAppsHook gobject-introspection ];

  buildInputs = [
    libayatana-appindicator
    gtk3
  ];

  pythonPath = [
    ewmh
    pygobject3
    setuptools
  ];

  dontWrapGApps = true;
  strictDeps = false;

  postInstall = ''
    cp -r etc $out/
  '';

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    maintainers = with maintainers; [ martinoz ];
    description = "Keep your computer awake";
    homepage = "https://launchpad.net/caffeine";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
