{
  description = "A template for Nix projects";

  outputs = { self }: {
    # Define the templates here
 
    # You can also define other templates
    templates.go = {
      path = ./go;
      description = "A Go project template with devShell";
    };
    
    templates.dotnet = {
      path = ./dotnet;
      description = "A dotnet project template with devShell";
    }

  };
}
