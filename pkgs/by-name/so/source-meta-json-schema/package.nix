{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:
let
  version = "10.0.0";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "source-meta-json-schema";
  inherit version;

  src = fetchFromGitHub {
    owner = "sourcemeta";
    repo = "jsonschema";
    rev = "v${version}";
    hash = "sha256-fYNbHU9DcSzMrMt+pDbbtPirTc+Wu4jq+vSqq+qzhtE=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    homepage = "https://github.com/sourcemeta/jsonschema";
    description = "CLI for working with JSON Schema. Covers formatting, linting, testing, bundling, and more for both local development and CI/CD pipelines ";
    changelog = "https://github.com/sourcemeta/jsonschema/releases";
    license = with lib.licenses; [
      agpl3Plus
    ];
    maintainers = with lib.maintainers; [
      amerino
    ];
    platforms = lib.platforms.all;
  };
})
