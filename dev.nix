# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-23.11"; # or "unstable"
  # Use https://search.nixos.org/packages to find packages
  packages = [];
  # Sets environment variables in the workspace
  env = {};
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "msjsdiag.vscode-react-native"
    ];
    workspace = {
      # Runs when a workspace is first created with this `dev.nix` file
      onCreate = {
        npm-install = ''
          npm i
        '';
      };
      # Runs when a workspace restarted
      onStart = {
        wait-for-device = ''
          adb -s localhost:5554 wait-for-device
        '';
      };
    };
    # Enable previews and customize configuration
    previews = {
      enable = true;
      previews = {
        web = {
          command = ["npm" "run" "web" "--" "--port" "$PORT"];
          manager = "web";
        };
        android = {
          command = ["npm" "run" "android" "--" "--port" "5554"];
          manager = "web";
        };
      };
    };
  };
}
