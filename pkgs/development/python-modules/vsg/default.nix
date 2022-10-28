{ lib
, buildPythonApplication
, fetchPypi
, pyyaml
, nose
}:

buildPythonApplication rec {
  pname = "vsg";
  version = "3.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Ad1ARD68zIFVfhX7LMWgBzWylFdjVd3NfQlfnZzxDTk=";
  };

  propagatedBuildInputs = [ pyyaml ];

  checkInputs = [ nose ];

  pythonImportsCheck = [ "vsg" ];

  meta = with lib; {
    description = "Style guide enforcement for VHDL";
    homepage = "https://github.com/jeremiah-c-leary/vhdl-style-guide";
    license = licenses.gpl3;
    maintainers = with maintainers; [  ];
  };
}
