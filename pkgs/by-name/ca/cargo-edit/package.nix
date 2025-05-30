{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-edit";
  version = "0.13.4";

  src = fetchFromGitHub {
    owner = "killercup";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gs7+OuW0av7p45+wgXVVS17YKTwIqDFQWc3kKE7y/Yw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-JafagbF+JCp3ATtGjlExLDUehYqO9DhI39uD4fLafsQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    zlib
  ];

  doCheck = false; # integration tests depend on changing cargo config

  meta = with lib; {
    description = "Utility for managing cargo dependencies from the command line";
    homepage = "https://github.com/killercup/cargo-edit";
    changelog = "https://github.com/killercup/cargo-edit/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      Br1ght0ne
      figsoda
      gerschtli
      jb55
      killercup
      matthiasbeyer
    ];
  };
}
