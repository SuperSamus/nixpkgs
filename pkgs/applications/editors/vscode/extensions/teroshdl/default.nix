{ lib
, vscode-utils
, python3
}:

vscode-utils.buildVscodeMarketplaceExtension rec {
  mktplcRef = {
    name = "teroshdl";
    publisher = "teros-technology";
    version = "2.0.7";
    sha256 = "sha256-RJKrAmd9p5OBnzxAYaZoOSAZIOGTbhnpjho9MqRX0AE=";
  };

  nativeBuildInputs = [ python3.pkgs.wrapPython ];

  propagatedBuildInputs = with python3.pkgs; [
    teroshdl
  ];

  # This is probably something to change https://github.com/TerosTechnology/vscode-terosHDL/blob/6408b8db8d6046ef1d4e5ebbdaca3e3392caaaed/src/lib/utils/extension_manager.ts#L44

  meta = with lib; {
    description = "Powerful IDE for ASIC/FPGA: state machine viewer, linter, documentation, snippets... and more!";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=teros-technology.teroshdl";
    homepage = "https://terostechnology.github.io/terosHDLdoc/";
    license = licenses.gpl3;
    #platforms = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
    maintainers = with maintainers; [ ];
  };
}
