{ lib
, buildPythonApplication
, fetchPypi
, colorama
}:

buildPythonApplication rec {
  pname = "vunit-hdl";
  version = "4.6.0";

  src = fetchPypi {
    inherit version;
    pname = "vunit_hdl";
    sha256 = "sha256-tAWpe12kwmyZ2Mcm84WUyRc8CsP4oIMkMcjkkg0srN8=";
  };

  propagatedBuildInputs = [ colorama ];

  doCheck = false;

  pythonImportsCheck = [ "vunit" ];

  meta = with lib; {
    description = "A unit testing framework for VHDL/SystemVerilog";
    homepage = "https://github.com/VUnit/vunit";
    license = licenses.mpl20;
    maintainers = with maintainers; [  ];
  };
}
