{ sources ? null }:
let
 deps = import ./nix/deps.nix { inherit sources; };
 pkgs = deps.pkgs;
 caBundle = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

in pkgs.mkShell {
  name = "pycryptpad-tools";
  buildInputs = deps.shellInputs;
  # A pure nix shell breaks SSL for git and nix tools which is fixed by setting the path to the certificate bundle.
  shellHook = ''
    export PYTHONPATH=./src
    export PATH=${deps.shellPath}:$PATH
    export NIX_SSL_CERT_FILE=${caBundle}
    export SSL_CERT_FILE=${caBundle}
  '';
}
