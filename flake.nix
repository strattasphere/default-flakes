{
  description = "A template for Nix projects";

  outputs = { self }: {
    # Define the templates here
 
    # You can also define other templates
    templates.go = {
      path = ./go;
      description = "A Go project template with devShell";
    };
    
    templates.wails3 = {
      path = ./wails3;
      description = "A Go & Svelte project template with devShell";
    };

    templates.dotnet = {
      path = ./dotnet;
      description = "A dotnet project template with devShell";
    };

    templates.rust = {
      path = ./rust;
      description = "A rust project template with devShell";
    };
  };
}
