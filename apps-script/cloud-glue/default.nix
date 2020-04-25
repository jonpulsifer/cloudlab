with (import <nixpkgs> {});
rec {
  cloud-glue = yarn2nix-moretea.mkYarnPackage {
    name = "cloud-glue";
    src = ./.;
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    yarnNix = ./yarn.nix;
  };
}
