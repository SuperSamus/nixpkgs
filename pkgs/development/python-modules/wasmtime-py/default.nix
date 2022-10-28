{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "wasmtime-py";
  version = "1.0.1"; # TODO 2.0.0
  format = "wheel";

  src = fetchPypi {
    inherit version format;
    pname = "wasmtime";
    dist = "py3";
    python = "py3";
    platform = "manylinux1_x86_64";
    sha256 = "sha256-slfsEbptOePNnu1PkMRjO887lkIZlIJUJENHI2/kUXI=";
  };

  propagatedBuildInputs = [ ];

  pythonImportsCheck = [ "wasmtime" ];

  meta = with lib; {
    description = "Python WebAssembly runtime powered by Wasmtime";
    homepage = "https://github.com/bytecodealliance/wasmtime-py";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}
