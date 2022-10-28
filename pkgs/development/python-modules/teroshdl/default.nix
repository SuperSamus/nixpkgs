{ lib
, buildPythonPackage
, fetchPypi
, edalize
, vunit-hdl
, vsg
, yowasp-yosys
}:

buildPythonPackage rec {
  pname = "teroshdl";
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IujXF2ToGbcPUAqWOjpMBQi4uw1nY36gkVrfRSv1EQw=";
  };

  propagatedBuildInputs = [ edalize vunit-hdl vsg yowasp-yosys ];

  meta = with lib; {
    description = "It groups python dependencies for TerosHDL";
    homepage = "https://terostechnology.github.io/";
    license = licenses.gpl3;
    maintainers = with maintainers; [  ];
  };
}
