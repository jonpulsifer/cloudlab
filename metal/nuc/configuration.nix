{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

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
  # nixpkgs.overlays = [ (import ./overlays/datadog.nix) ];

  boot = {
    kernelPackages = pkgs.unstable.linuxPackages_5_4;
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
    search = [ "home.pulsifer.ca" "lan" "local" ];

    # networkd does not support useDHCP globally
    useNetworkd = true;
    useDHCP = false;

    # per interface config
    # lan
    interfaces.eno1.useDHCP = true;

    # wireless
    wireless.enable = false;
    interfaces.wlp0s20f3.useDHCP = false;

    wireguard.interfaces = {
      wg0 = {
        ips = [ "10.13.37.4/32" ];
        allowedIPsAsRoutes = true;
        peers = [{
          allowedIPs = [ "10.13.37.0/24" ];
          endpoint = "35.212.58.58:51820";
          publicKey = "ueM0mPsMfsj67gl+Z2e89uwWPN76rgsRKkAOrW4aHFk=";
        }];
        privateKeyFile = "/var/secret/wireguard";
      };
    };
  };

  boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];
  systemd.network = {
    enable = true;
    netdevs = {
      "10-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          MTUBytes = "1300";
          Name = "wg0";
        };
        # See also man systemd.netdev
        extraConfig = ''
          [WireGuard]
          # Currently, the private key must be world readable, as the resulting netdev file will reside in the Nix store.
          PrivateKey=hehehe
          ListenPort=51824

          [WireGuardPeer]
          PublicKey = somkey
          AllowedIPs = 10.13.37.0/24
          Endpoint = 127.0.0.1:51820
          PersistentKeepalive = 25
        '';
      };
    };
    networks = {
      # See also man systemd.network
      "40-wg0".extraConfig = ''
        [Match]
        Name=wg0

        [Network]
        DHCP=none
        Gateway=10.13.37.1

        [Address]
        Address=10.13.37.4/24
      '';
    };
  };
  i18n = {
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Canada/Eastern";

  environment.systemPackages = with pkgs; [ bash bash-completion nixfmt ];

  services.cron.enable = true;
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

  services.minecraft-server = {
    enable = false;
    eula = true;
    openFirewall = true;
    declarative = false;
    jvmOpts =
      "-Xms8G -Xmx8G -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=50 -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 -XX:G1MixedGCLiveThresholdPercent=35";
  };

  virtualisation.docker.enable = true;

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
      i3.enable = true;
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
    packages = with pkgs; [ feh chromium xdotool ];
  };

  users.users.jawn = {
    uid = 1337;
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJewr6lJtffl+uZpnWXTIE5Sd3VeytQRGXKMBv1s5R/v"
    ];

    packages = with pkgs; [ home-manager ];
  };

  system = {
    stateVersion = "19.09";
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-19.09";
    };
  };
}
