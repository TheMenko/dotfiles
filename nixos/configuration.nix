# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Include unstable
      ./unstable.nix
    ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Belgrade";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Install HyperLand window manager and enable xwayland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    xwayland.hidpi = true;
  };
  programs.zsh.enable = true;
  programs.thunar.enable = true;
  nixpkgs.config.permittedInsecurePackages = [
    "python-2.7.18.6"
  ];
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.menko = {
    isNormalUser = true;
    description = "Menko";
    extraGroups = [ "networkmanager" "docker" "wheel" "video" "kvm"];
    packages = with pkgs; [helix];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowInsecure = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    cargo
    clang
    cmake
    docker
    dunst
    easyeffects
    firefox-wayland
    flameshot
    fzf
    git
    grim
    htop
    kitty
    killall
    libnotify
    libsecret
    libvirt
    looking-glass-client
    megasync
    meson
    ninja
    p7zip
    pavucontrol
    python2
    python3
    pywal
    qemu_kvm
    qt5.qtwayland
    qt6.qtwayland
    ripgrep
    rofi-wayland
    rustup
    sddm
    slack
    slurp
    steam
    swww
    swaylock
    unzip
    wally-cli
    waybar
    wget
    wl-clipboard
    wlogout
    wlroots
    xwayland
    ydotool
  ];
  
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    liberation_ttf
    fira-code
    fira-code-symbols
    nerdfonts
    font-awesome
  ];

  # XDG portal - screenshare and such
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-hyprland 
    pkgs.xdg-desktop-portal-gtk 
  ];

  # Pipewire
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  services.blueman.enable = true;


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.051"; # Did you read the comment?
  
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true"];
      });
    })
  ];
}