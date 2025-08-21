# f sfEdit this configuration file to define what should be installed on
# system.  Help is available in the configuration.nix(5) man page.
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:
let
  progLangauge = with pkgs; [
    bun
    go
    astro-language-server
    gccgo
    csharp-ls
    dotnet-sdk
    java-language-server
    kotlin-language-server
    gopls
    cargo
    gcc
    nodejs_20
    typescript
    typescript-language-server
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
    gradle
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
    pyright
    rustc
    rustfmt
    rustup
    rust-analyzer
    emmet-language-server
    stylua
    htmx-lsp
    tailwindcss-language-server
    yarn
    gdtoolkit_4
    isort
    vscode-langservers-extracted
    tinymist
    c3c
    c3-lsp
  ];

  wgpu-native-static = pkgs.wgpu-native.overrideAttrs (old: {
    postInstall = ''
      install -Dm644 ./ffi/wgpu.h -t $dev/include/webgpu
      install -Dm644 ./ffi/webgpu-headers/webgpu.h -t $dev/include/webgpu
    '';
  });

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
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
    networkmanager-openconnect
    networkmanager-vpnc
    networkmanager-l2tp
    networkmanager-sstp
    networkmanager-iodine
    networkmanager-fortisslvpn
  ];

  # Intel Graphics
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # your Open GL, Vulkan and VAAPI drivers
      # vpl-gpu-rt # for newer GPUs on NixOS >24.05 or unstable
      # onevpl-intel-gpu  # for newer GPUs on NixOS <= 24.05
      # intel-media-sdk   # for older GPUs

      rocmPackages.clr.icd
    ];
    enable32Bit = true;
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

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

  # List services that you want to enable:
  services = {
    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    xserver = {
      enable = true;
      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };
      videoDrivers = [ "amdgpu" ];
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    blueman.enable = true;
    logmein-hamachi.enable = true;
    getty.autologinUser = "myt";

    openssh.enable = true;

    # Thunderbolt
    hardware.bolt.enable = true;
    ratbagd.enable = true;

    # Enable CUPS to print documents.
    printing.enable = true;

    languagetool.enable = true;

    # Auto Mount
    udisks2.enable = true;
    gnome.gnome-keyring.enable = true;
    # Enable sound with pipewire.
    pulseaudio.enable = false;
    pipewire = {
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

    hardware.openrgb.enable = true;
  };

  nix.settings.experimental-features = "nix-command flakes";

  # Configure console keymap
  console.keyMap = "us";

  security.rtkit.enable = true;
  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  virtualisation.docker.enable = true;
  services.udev.packages = with pkgs; [
    via
  ];
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
    packages =
      with pkgs;
      [
        iwgtk
        clinfo
        wine
        walker
        via
        networkmanagerapplet
        whitebox-tools
        linux-wallpaperengine
        localsend
        turso-cli
        httpie-desktop
        httpie
        playerctl
        blockbench
        blender
        comma
        itch
        feh
        pamixer
        camunda-modeler
        gnumake
        vscode
        code-cursor
        libuchardet
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
        gimp3
        lxde.lxtask
        mgba
        typst
        rgbds
        parallel
        gf
        opencode
        lmstudio
        ollama
        # wgpu-native
        wgpu-utils
        ruby
        jekyll
      ]
      ++ [
        wgpu-native-static
      ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GIT_ASKPASS = "1";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  programs = {
    niri.enable = true;
    fish.enable = true;
    light.enable = true;
    nix-ld.enable = true;
    dconf.enable = true;
    # hyprlock.enable = true;

    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    gamescope = {
      enable = true;
      capSysNice = true;
    };

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
      ];
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    };

    git = {
      enable = true;
      package = pkgs.gitFull;
    };

    nix-ld.libraries = with pkgs; [
      wayland
      glfw

      raylib
      pkgs.xorg.libX11
      pkgs.xorg.libX11.dev
      pkgs.xorg.libXcursor
      pkgs.xorg.libXi
      pkgs.xorg.libXinerama
      pkgs.xorg.libXrandr
    ];

    nm-applet.enable = true;
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages =
    with pkgs;
    [
      mangohud
      polkit_gnome
      inotify-tools
      gnome-keyring
      polkit
      openconnect
      libreoffice-qt
      hunspell
      hunspellDicts.en_US
      hunspellDicts.de_DE
      brave
      firefox
      netflix
      jq
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
      slurp
      grim
      btrfs-progs
      waypaper
      polychromatic
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
      wl-clipboard
      spotify-unwrapped
      nixfmt-rfc-style
      alejandra
      bemoji
      fzf
      fuzzel
      wtype
      jetbrains.idea-ultimate
      jetbrains.rider
      jetbrains.pycharm-professional
      jetbrains.clion
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
      openrgb
      kdePackages.qtstyleplugin-kvantum
      kdePackages.qt6ct
      themechanger
      hyprpicker
      tesseract
      openvpn
      swww
      mpvpaper
      cloc
      networkmanager-openvpn
      gparted
      xwayland-satellite
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  systemd = {
    coredump.enable = true;
    user.services.waybar = {
      enable = true;
      description = "Start waybar";
      wantedBy = [ "graphical.target" ];
      after = [ "graphical.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = ''${pkgs.waybar}/bin/waybar'';
      };
      restartTriggers = [
        "on-failure"
      ];
    };
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  security.polkit.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.supportedFilesystems = [ "ntfs" ];
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 53317 ];
  # networking.firewall.allowedUDPPorts = [ 53317 ];

  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  system.autoUpgrade = {
    enable = true;
  };

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
