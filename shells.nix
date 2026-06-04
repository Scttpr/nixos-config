{ pkgs }:

{
  binanalysis = {
    packages = with pkgs; [
      radare2

      gdb
      gef
      strace
      ltrace

      binutils
      elfutils
      patchelf
      file
      hexyl
      xxd

      binwalk
      yara
      entropy

      wireshark-cli
    ];
  };

  rust = {
    packages = with pkgs; [
      rustc
      cargo
      rust-analyzer
      clippy
      rustfmt
      cargo-watch
      cargo-edit
    ];

    RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
  };

  hamradio = {
    packages = with pkgs; [
      sdrpp
      gqrx
      rtl-sdr

      inspectrum
      urh
      rtl_433
      gnuradio

      wsjtx
      fldigi

      direwolf

      multimon-ng

      satdump
      gpredict

      adif-multitool
      hamlib

      chirp
    ];
  };

  netsec = {
    packages = with pkgs; [
      nmap
      masscan

      dig
      whois
      dnsenum

      tcpdump
      wireshark-cli
      ngrep

      mitmproxy
      ettercap

      python3Packages.scapy

      curl
      wget
      nikto
      ffuf

      metasploit
      sqlmap
      hydra
      john
      hashcat

      aircrack-ng

      enum4linux-ng
      onesixtyone

      netcat-gnu
      socat
      proxychains-ng
      chisel
      openvpn
      wireguard-tools
      inetutils

      openssl
      testssl
    ];
  };

  llm = {
    packages = with pkgs; [
      ollama-cpu
      aichat
      python3
      uv
    ];
  };
}
