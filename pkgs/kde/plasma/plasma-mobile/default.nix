{
  mkKdeDerivation,
  pkg-config,
  qtsensors,
  qtwayland,
  plasma-workspace,
}:
mkKdeDerivation {
  pname = "plasma-mobile";

  extraNativeBuildInputs = [
    pkg-config
    qtsensors
    qtwayland
  ];

  extraBuildInputs = [
    qtsensors
    qtwayland
  ];

  postFixup = ''
    substituteInPlace "$out/share/wayland-sessions/plasma-mobile.desktop" \
      --replace-fail \
        "$out/libexec/plasma-dbus-run-session-if-needed" \
        "${plasma-workspace}/libexec/plasma-dbus-run-session-if-needed"
  '';
  passthru.providedSessions = [ "plasma-mobile" ];
}
