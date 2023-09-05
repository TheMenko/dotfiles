{ config, pkgs, ...}:
let
  baseconfig = { allowUnfree = true; };
  unstable = import <unstable> { config = baseconfig; };
in {
  environment.systemPackages = with pkgs; [
    unstable.wallust
    unstable.helix
  ];
}