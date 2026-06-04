{ pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    package = pkgs.chromium;

    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-features=VaapiVideoDecodeLinuxGL,WaylandWindowDecorations"
    ];

    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
      { id = "ghmbeldphafepmbegfdlkpapadhbakde"; }
    ];
  };
}
