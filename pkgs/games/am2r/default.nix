{ lib
, stdenv
, fetchFromGitHub
, requireFile
, autoPatchelfHook
, copyDesktopItems
, makeDesktopItem
, makeWrapper
, unzip
, xdelta # Override to avoid building 32-bit version

, libGL
, libX11
, libXcursor
, openal
, linuxConsoleTools
, jstest-gtk

, hqMusic ? true
, modifiersIni ? null

, desktopName ? "AM2R"
}:

let
  owner = "AM2R-Community-Developers";
  repo = "AM2R-Autopatcher-Linux";
  rev = "56d7dd2d3612c42fc1de9644b8752512c0af51af";
  libSrc = let sparseCheckout = "/data/AM2R.AppDir/usr/lib32"; in
    fetchFromGitHub
      {
        inherit owner repo rev sparseCheckout;
        sha256 = "sha256-nkZP+q9BsDx45RvkeeBOqbvHZU2pUNgiuRxhkMRHoec=";
      } + sparseCheckout;

  hqMusicSrc = let sparseCheckout = "/data/HDR_HQ_in-game_music"; in
    fetchFromGitHub
      {
        inherit owner repo rev sparseCheckout;
        sha256 = "sha256-NB5PqF2sYgEskULq0aQgpM0ab7H3VL/LuZ7lcI6O9Ck=";
      } + sparseCheckout;
in
stdenv.mkDerivation rec {
  pname = "am2r";
  version = "1.5.5";

  src = stdenv.mkDerivation rec {
    name = "AM2R_11";
    src = requireFile {
      name = "${name}.zip";
      sha256 = "sha256-+j0JMbr4shi2qLTOnrjhjKEeFCw08LQE1AXYMA7w+kw=";
      message = ''
        Due to Nintendo's DMCA takedown, we cannot download the original AM2R 1.1 zip automatically.
        Please retrieve the original file yourself, extract the contents to a folder named ${name},
        and add it to the Nix store using
          nix-store --add-fixed sha256 ${name}.zip
      '';
    };
    nativeBuildInputs = [ unzip ];
    installPhase = "cp -r ../. $out";
    meta.license = lib.licenses.unfree;
  };

  patch = let sparseCheckout = "/data"; in
    fetchFromGitHub
      {
        inherit owner repo rev sparseCheckout;
        sha256 = "sha256-MBAO7U13+8kMFrgG0GAruUCMX4xWXK8wskfHxlwtNcU=";
      } + sparseCheckout;

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
    xdelta
  ];

  buildInputs = [
    libGL
    libX11
    libXcursor
    openal
    stdenv.cc.cc.lib
    jstest-gtk # Required for gamepad
  ];

  desktopItems = lib.singleton (makeDesktopItem {
    inherit desktopName;
    name = pname;
    exec = pname;
    icon = "icon";
    type = "Application";
    categories = [ "Game" ];
    comment = meta.description;
  });

   # https://github.com/AM2R-Community-Developers/AM2RLauncher/blob/main/AM2RLauncher/AM2RLauncherLib/Profile.cs#L334
  buildPhase = ''
    mkdir -p $out/bin
    xdelta3 -d -s $src/data.win $patch/game.xdelta $out/bin/game.unx
    xdelta3 -d -s $src/AM2R.exe $patch/AM2R.xdelta $out/bin/${pname}
  '';

  installPhase = ''
    runHook preInstall

    cp -r $src $out/bin/assets/
    chmod a+w -R $out/bin/assets
    cp -r $patch/files_to_copy/. $out/bin/assets/

    mkdir -p $out/share/icons/hicolor/72x72/apps
    mv $out/bin/assets/icon.png $out/share/icons/hicolor/72x72/apps/

    rm $out/bin/assets/{D3DX9_43.dll,AM2R.exe,data.win}
  ''
  # Extract the libraries from the community patch if it's not in the selected patch
  + (
    let libSource =
      if builtins.pathExists "${patch}/AM2R.AppDir/usr/lib32" then "${patch}/AM2R.AppDir/usr/lib32" else libSrc;
    in
    ''
      cp -r ${libSource}/. $out/lib/
    ''
  )
  # Extract high quality music from the community patch if it's not in the selected patch
  + lib.optionalString hqMusic (
    let hqMusicSource =
      if builtins.pathExists "${patch}/HDR_HQ_in-game_music" then "${patch}/HDR_HQ_in-game_music" else hqMusicSrc;
    in
    ''
      cp -rf ${hqMusicSource}/. $out/bin/assets
    ''
  )
  + ''
    # Rename music to lowercase
    for file in $out/bin/assets/*.ogg; do
      mv -f $file $(echo $file | tr '[:upper:]' '[:lower:]') || true
    done
  '' + lib.optionalString (modifiersIni != null) ''
    cp -f $modifiersIni $out/bin/assets/modifiers.ini

    runHook postInstall
  '';

  postFixup = ''
    chmod a+x $out/bin/${pname}
    wrapProgram $out/bin/${pname} --set radeonsi_sync_compile "true"
  '';

  meta = with lib; {
    description = "Another Metroid 2 Remake (Community Edition)";
    longDescription = "Another Metroid 2 Remake is an unofficial fan remake of Metroid II: Return of Samus, with community patches";
    homepage = "https://github.com/AM2R-Community-Developers/AM2RLauncher";
    changelog = "https://am2r-community-developers.github.io/DistributionCenter/changelog.html";
    license = licenses.gpl3;
    maintainers = [ maintainers.martfont ];
    platforms = platforms.linux;
  };
}
