{
  description = "Venv virtual environment with python the nix way";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    pythonPackages = pkgs.python3Packages;
  in {
    devShells."${system}".default =
      pkgs.mkShell rec
      {
        name = "python-venv";
        venvDir = "./.venv";
        nativeBuildInputs = with pkgs; [
          python312
          gcc14Stdenv
          nodejs
        ];

        buildInputs = with pythonPackages; [
          # Common packages
          numpy
          pandas
          matplotlib
          scipy
          sympy
          jedi
          seaborn
          requests

          # REPL
          jupyter
          ipython
          ipympl
          ipykernel
          nbformat

          # Machine Learning
          scikit-learn-extra
          tensorflow
        ];

        postShellHook = ''
          # allow pip to install wheels
          unset SOURCE_DATE_EPOCH
        '';
      };
  };
}
