{
  description = "Venv virtual environment with python";

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
        ];

        buildInputs = with pythonPackages; [
          venvShellHook
          numpy
          jupyter
        ];

        # Run this command, only after creating the virtual environment
        postVenvCreation = ''
          unset SOURCE_DATE_EPOCH
          curl "https://raw.githubusercontent.com/alvarorc19/python-flake/refs/heads/main/requirements.txt" >> requirements.txt
          pip install -r requirements.txt
        '';

        # Now we can execute any commands within the virtual environment.
        # This is optional and can be left out to run pip manually.
        postShellHook = ''
          # allow pip to install wheels
          unset SOURCE_DATE_EPOCH
        '';
      };
  };
}
