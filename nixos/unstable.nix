{ config, pkgs, ...}:
let
  baseconfig = { allowUnfree = true; };
  unstable = import <unstable> { config = baseconfig; };
in {
  environment.systemPackages = with pkgs; [
    unstable.wallust
    unstable.helix
    unstable.pipewire
    unstable.wireplumber
    unstable.lutris
    # winetricks (all versions)
    unstable.winetricks
    unstable.steam
    unstable.protontricks
    unstable.wine
    # native wayland support (unstable)
    unstable.wineWowPackages.waylandFull
    unstable.godot_4
  ];
}