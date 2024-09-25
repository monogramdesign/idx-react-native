{ pkgs, packageManager ? "npm", openIn ? "go", ... }: {
  packages = [
    pkgs.nodejs_20
    pkgs.yarn
    pkgs.nodePackages.pnpm
    pkgs.bun
    pkgs.j2cli
    pkgs.nixfmt
    pkgs.jq
  ];
  bootstrap = ''
    mkdir -p "$WS_NAME"
    ${
      if packageManager == "pnpm" then "pnpm create expo \"$WS_NAME\" --no-install"
      else if packageManager == "bun" then "bun create expo \"$WS_NAME\" --no-install"
      else if packageManager == "yarn" then "yarn create expo \"$WS_NAME\" --no-install" 
      else "npm create expo \"$WS_NAME\" --no-install"
    }
    mkdir "$WS_NAME/.idx/"
    packageManager=${packageManager} openIn=${openIn} j2 ${./devNix.j2} -o "$WS_NAME/.idx/dev.nix"
    nixfmt "$WS_NAME/.idx/dev.nix"
    packageManager=${packageManager} openIn=${openIn} j2 ${./README.j2} -o "$WS_NAME/README.md"

    ${if openIn == "development" then ''
      # Add android package name
      jq '.expo.android.package = "com.anonymous." + env.WS_NAME' "$WS_NAME/app.json" > "$WS_NAME/app.json.tmp" && mv "$WS_NAME/app.json.tmp" "$WS_NAME/app.json"
    '' else ""}

  
    chmod -R +w "$WS_NAME"
    mv "$WS_NAME" "$out"
  '';
}

