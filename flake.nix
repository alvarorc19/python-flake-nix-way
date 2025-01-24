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

    # Fetch the raw requirements.txt from GitHub
    requirementsTxt = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/alvarorc19/python-flake/main/requirements.txt";
      sha256 = "1dmxh8w6nvh3xvy8y3vwp7bl7g98xh66w38g9jlbr78fh9pwpkxv";
    };
  in {
    devShells."${system}".default =
      pkgs.mkShell rec
      {
        name = "python-venv";
        venvDir = "./.venv";
        nativeBuildInputs = with pkgs; [
          python312
          clang
        ];

        buildInputs = with pythonPackages; [
          venvShellHook
          numpy
        ];

        # Run this command, only after creating the virtual environment
        postVenvCreation = ''
          unset SOURCE_DATE_EPOCH
          echo "Downloading requirements.txt..."
          cp ${requirementsTxt} requirements.txt
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
