# f sfEdit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page.
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:
let
  # unstable = import inputs.unstable {
  #   inherit system;
  #   config.allowUnfree = true;
  # };

  progLangauge = with pkgs; [
    go
    java-language-server
    kotlin-language-server
    gopls
    cargo
    gcc
    nodejs_20
    typescript
    air
    nil
    tailwindcss
    templ
    pnpm
    cmake
    meson
    nixd
    sqlite
    goose
    ninja
    odin
    ols
    zig
    jdk23
    jdt-language-server
    hyprls
    maven
    clang_19
    clang-tools_19
    groovy
    wezterm
    godot
    kotlin
    zls
    kotlin-native
    lua
    lua-language-server
    luarocks

  ];

in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "nixos"; # Define your hostname.

  # Configure network proxy if necessary.
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Thunderbolt
  services.hardware.bolt.enable = true;
  # Intel Graphics
  hardware.graphics = {
    enable = true;
    # extraPackages = with pkgs; [
    # your Open GL, Vulkan and VAAPI drivers
    # vpl-gpu-rt # for newer GPUs on NixOS >24.05 or unstable
    # onevpl-intel-gpu  # for newer GPUs on NixOS <= 24.05
    # intel-media-sdk   # for older GPUs
    # ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  nix.settings.experimental-features = "nix-command flakes";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Auto Mount
  services.udisks2.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  virtualisation.docker.enable = true;

  services.ratbagd.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.myt = {
    isNormalUser = true;
    description = "My Toaster";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "openrazer"
      "ratbagd"
      "docker"
    ];
    packages = with pkgs; [
      wine
      localsend
      httpie-desktop
      httpie
      playerctl
      blockbench
      blender
      itch
      feh
      pamixer
      gnumake
      vscode
      libuchardet
      typescript
      dissent
      discord-canary
      pandoc
      texliveTeTeX
      typora
      htop
      weylus
      ghostty
      legcord
      winetricks
      protontricks
      protonup-qt
    ];
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Install firefox.
  # programs.firefox.enable = true;
  # services.gnome.gnome-keyring.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
  };

  programs.fish.enable = true;
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GIT_ASKPASS = "1";
  };

  programs.light.enable = true;
  programs.nix-ld.enable = true;
  programs.dconf.enable = true;
  programs.nix-ld.libraries = with pkgs; [ wayland ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
    ];
  };

  programs.openvpn3.enable = true;
  programs.nm-applet.enable = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages =
    with pkgs;
    [
      libreoffice
      brave
      tmux-sessionizer
      tmux
      stow
      ffmpeg
      vim
      piper
      pavucontrol
      wget
      clipboard-jh
      yaru-theme
      waybar
      hyprpolkitagent
      slurp
      grim
      polychromatic
      openvpn
      adapta-kde-theme
      adwaita-qt6
      xorg.xcursorthemes
      hyprpaper
      starship
      unzip
      ripgrep
      lxappearance
      lf
      aseprite
      dracula-icon-theme
      fastfetch
      nwg-look
      libsForQt5.qt5ct
      kdePackages.qt6ct
      wl-clipboard
      spotify
      nixfmt-rfc-style
      alejandra
      bemoji
      fzf
      fuzzel
      wtype
      jetbrains.idea-ultimate
      jetbrains.pycharm-professional
      jetbrains.clion
      gamescope
      bottles
      heroic
      lutris
      carapace
      logmein-hamachi
      haguichi
      colloid-kde
      colloid-gtk-theme
      colloid-icon-theme
      blueman
      killall
      miru
      kdePackages.qtstyleplugin-kvantum
      themechanger
      hyprpicker
    ]
    ++ progLangauge;

  environment.localBinInPath = true;

  # ADD FONTS
  fonts.packages =
    with pkgs;
    [
      corefonts
      vistafonts
      roboto
    ]
    ++ (with pkgs.nerd-fonts; [
      jetbrains-mono
      fira-code
    ]);

  # fonts.packages = with pkgs; [
  #   (nerdfonts.override {
  #     fonts = [
  #       "JetBrainsMono"
  #       "FiraCode"
  #       "DroidSansMono"
  #     ];
  #   })
  #   roboto
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.blueman.enable = true;
  services.logmein-hamachi.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  security.polkit.enable = true;
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 53317 ];
  # networking.firewall.allowedUDPPorts = [ 53317 ];

  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  system.autoUpgrade = {
    enable = true;
  };

  environment.sessionVariables = { };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  nix.settings = {
    trusted-users = [
      "root"
      "myt"
    ];
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  # Use GC
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

}
