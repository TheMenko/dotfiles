# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Include unstable
      ./unstable.nix
      # Custom environment
      # ./environment.nix
    ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };  
  hardware.keyboard.zsa.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.enable = true;
  hardware.opentabletdriver.enable = true;

  boot.kernelParams = [ "radeon.cik_support=0" "amdgpu.cik_support=1" ];
  hardware.opengl.driSupport = true;

  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
  ];
  # For 32 bit applications 
  # Only available on unstable
  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];

  # Force radv
  environment.variables.AMD_VULKAN_ICD = "RADV";
  
  nix.settings.auto-optimise-store = true;  
  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  security.polkit.enable = true;
  
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
  };
  programs.zsh = {
    enable = true;
     ohMyZsh = {
      enable = true;
      plugins = [ "git" "thefuck" "ripgrep"
        "autojump" 
      ];
      theme = "robbyrussell";
    };
  };
  programs.thunar.enable = true;
  programs.gamemode.enable = true;
  nixpkgs.config.permittedInsecurePackages = [
    "python-2.7.18.6"
  ];
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  # Pipewire
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.flatpak.enable = true;
    
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    OPENSSL_DIR = pkgs.openssl.dev;
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    XDG_CURRENT_DESKTOP="Hyprland";
    QT_QPA_PLATFORM="wayland";
    XDG_SESSION_TYPE="wayland";
    XDG_SESSION_DESKTOP="Hyprland";
    MOZ_ENABLE_WAYLAND="1";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.menko = {
    isNormalUser = true;
    description = "Menko";
    extraGroups = [ "networkmanager" "docker" "wheel" "video" "kvm" "audio"];
    packages = with pkgs; [
    thefuck
    ripgrep
    autojump
    vulkan-tools
    ];
  };
  users.defaultUserShell = pkgs.zsh;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowInsecure = true;

  environment.shells = with pkgs; [zsh];
  
  
  programs.ssh.startAgent = true;
  services.xserver.displayManager.session = [
    {
      manage = "desktop";
      name = "hyprland";
      start = ''
        ${lib.getExe pkgs.hyprland} &
        waitPID=$!
      '';
    }
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    cargo
    clang
    cmake
    dbeaver
    (pkgs.discord.override {
      # remove any overrides that you don't want
      withOpenASAR = true;
      withVencord = true;
    })
    webcord-vencord
    docker
    dunst
    dbus
    easyeffects
    firefox-wayland
    fzf
    git
    grim
    glib
    gparted
    htop
    kitty
    killall
    libnotify
    libsecret
    libvirt
    looking-glass-client
    megasync
    meson
    mold
    ninja
    openssl
    opentabletdriver
    perl
    p7zip
    pavucontrol
    python2
    python3
    pywal
    pkgconfig
    qemu_kvm
    qt5.qtwayland
    qt6.qtwayland
    qt6.full
    ripgrep
    rofi-wayland
    rustup
    sddm
    slack
    slurp
    swww
    swappy
    swaylock
    unzip
    wally-cli
    waybar
    wget
    wl-clipboard
    wlogout
    wlroots
    xwayland
    xdg-utils
    ydotool
  ];


  fonts.fontDir.enable = true;
  fonts.fonts= with pkgs; [
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
  system.stateVersion = "23.05"; # Did you read the comment?
  
  nixpkgs.overlays = [
    (self: super: {
        waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true"];
      });
    })
  ];
}
