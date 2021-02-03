self: super: {
  # jre = super.openjdk11;
  minecraft-server = super.minecraft-server.overrideAttrs (oldAttrs: rec {
    version = "1.15.2";
    src = super.fetchurl {
      url =
        "https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar";
      sha256 =
        "80cf86dc2004ec6a2dc0183d1c75a9af3ba0669f7c332e4247afb1d76fb67e8a";
    };
  });
}
