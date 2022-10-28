{ lib
, buildPythonApplication
, fetchPypi
, wasmtime-py
, appdirs
}:

buildPythonApplication rec {
  pname = "yowasp-yosys";
  version = "0.22.post33.dev433";
  format = "wheel";

  src = fetchPypi {
    inherit version format;
    pname = "yowasp_yosys";
    dist = "py3";
    python = "py3";
    sha256 = "sha256-zVmmlK8kDaE7V8bJkQcbF5aHN0uvDN8C9aR/D1jCX6M=";
  };

  propagatedBuildInputs = [ wasmtime-py appdirs ];

  meta = with lib; {
    description = "Unofficial Yosys WebAssembly packages";
    homepage = "https://yowasp.github.io/";
    license = licenses.isc;
    maintainers = with maintainers; [  ];
  };
}
