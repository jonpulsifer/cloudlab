{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    consoleLogLevel = 0;
    loader = {
      # Use the systemd-boot EFI boot loader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = pkgs.lib.mkForce 0;
    };
  };

  networking = {
    hostName = "nuc";
    nameservers = [ "8.8.8.8" "8.8.4.4" "1.1.1.1" "1.0.0.1" ];

    wireless.enable = false; # Enables wireless support via wpa_supplicant.

    useDHCP = false;
    interfaces.eno1.useDHCP = true;
    interfaces.wlp0s20f3.useDHCP = false;
  };

  i18n = {
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Canada/Eastern";

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import <nixos-unstable> {
        # pass the nixpkgs config to the unstable alias
        # to ensure `allowUnfree = true;` is propagated:
        config = config.nixpkgs.config;
      };
    };
  };

  environment.systemPackages = with pkgs; [ bash-completion nixfmt ];

  # Enable the OpenSSH daemon.
  services.sshguard.enable = true;
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    challengeResponseAuthentication = false;
    permitRootLogin = "no";
    hostKeys = [{
      type = "ed25519";
      path = "/etc/ssh/ssh_host_ed25519_key";
    }];
  };

  services.datadog-agent = {
    enable = true;
    apiKeyFile = "/var/secrets/datadog";
    tags = [ "os:linux" "os:nixos" "location:ottawa" ];
    hostname = "nuc.home.pulsifer.ca";
    enableLiveProcessCollection = true;
  };

  services.xserver = {
    enable = true;

    monitorSection = ''
      Option "NODPMS"
    '';

    serverFlagsSection = ''
      Option "DPMS" "false"
      Option "BlankTime" "0"
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime" "0"
    '';

    displayManager = {
      auto = {
        enable = true;
        user = "kiosk";
      };
      slim.enable = false;
      xserverArgs = [ "-nocursor" ];
    };

    desktopManager = {
      default = "none";
      xterm.enable = false;
    };

    windowManager = {
      default = "i3";
      i3 = {
        enable = true;
        #extraPackages = with pkgs; [
        #];
      };
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  users.users.kiosk = {
    isNormalUser = true;
    packages = with pkgs; [ feh chromium ];
  };

  users.users.jawn = {
    uid = 1337;
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJewr6lJtffl+uZpnWXTIE5Sd3VeytQRGXKMBv1s5R/v"
    ];

    packages = with pkgs; [
      fzf
      exa
      fd
      git
      git-radar
      gnumake
      neofetch
      nodejs
      pinentry
      tmux
      unstable.go
      unzip
      vim
      wget
    ];
  };

  system = {
    stateVersion = "19.09";
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-19.09";
    };
  };
}
