{
  description = "A template for Nix projects";

  outputs = { self, nixpkgs }: {
    # Define the templates here
    templates.default = {
      path = ./templates/default;
      description = "A basic Nix project template with a hello world package";
    };
 
    # You can also define other templates
    templates.go = {
      path = ./templates/go;
      description = "A Go project template with devShell";
    };
  };
}
