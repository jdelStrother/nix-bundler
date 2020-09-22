{ pkgs ? import <nixpkgs> {} }:

let
  gems = pkgs.bundlerEnv {
    name = "gems-for-nix-bundler";
    gemdir = ./.; # loads gemset.nix
    gemConfig = pkgs.defaultGemConfig // {
      ruby-audio = attrs: {
        hardeningDisable = pkgs.stdenv.lib.optional pkgs.stdenv.isDarwin "format";
        buildInputs = [ pkgs.libsndfile ];
      };
    };
    postBuild = ''
      # We want the version of bundler in the wrappedRuby package, not this one
      rm $out/bin/{bundle,bundler}
    '';
  };


in pkgs.mkShell {
  buildInputs = [
    gems
    gems.wrappedRuby
  ];
}
