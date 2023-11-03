{ config, pkgs, lib, ...}:
let
  baseconfig = { allowUnfree = true; };
  unstable = import <unstable> { config = baseconfig; };
  in {

  hardware.opengl = {
    enable = true;
    package = pkgs.mesa.drivers;
    driSupport32Bit = true;
    driSupport = true;
  };
   
  services.xserver.displayManager.session = [
    {
      manage = "desktop";
      name = "hyprland";
      start = ''
        ${lib.getExe unstable.hyprland} &
        waitPID=$!
      '';
    }
  ];
  
  environment.systemPackages = with pkgs; [
    unstable.easyeffects
    unstable.godot_4
    unstable.glibc
    unstable.helix
    unstable.hyprland
    unstable.kitty
    unstable.lutris
    unstable.protontricks
    unstable.rustup
    unstable.steam
    unstable.steam-run
    unstable.slack
    unstable.typst
    unstable.vesktop
    unstable.wallust
    unstable.winetricks
    unstable.wineWowPackages.waylandFull
    unstable.xwayland
  ];
}
