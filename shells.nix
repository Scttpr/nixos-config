{ pkgs }:

{
  binanalysis = {
    packages = with pkgs; [
      # disassembler
      radare2

      # debuggers / tracing
      gdb
      gef
      strace
      ltrace

      # binary utilities
      binutils
      elfutils
      patchelf
      file
      hexyl
      xxd

      # forensics / analysis
      binwalk
      yara
      entropy

      # network
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
      # sdr
      sdrpp
      gqrx
      rtl-sdr

      # rf analysis & reverse engineering
      inspectrum
      urh
      rtl_433
      gnuradio

      # digital modes
      wsjtx
      fldigi

      # packet / aprs
      direwolf

      # signal decoding
      multimon-ng

      # satellite
      satdump
      gpredict

      # logging
      adif-multitool
      hamlib

      # radio programming
      chirp
    ];
  };

  netsec = {
    packages = with pkgs; [
      # reconnaissance
      nmap
      masscan

      # dns
      dig
      whois
      dnsenum

      # traffic capture & analysis
      tcpdump
      wireshark-cli
      ngrep

      # traffic manipulation
      mitmproxy
      ettercap

      # packet crafting
      python3Packages.scapy

      # http / web
      curl
      wget
      nikto
      ffuf

      # exploitation
      metasploit
      sqlmap
      hydra
      john
      hashcat

      # wireless
      aircrack-ng

      # smb / snmp enumeration
      enum4linux-ng
      onesixtyone

      # network utilities
      netcat-gnu
      socat
      proxychains-ng
      chisel
      openvpn
      wireguard-tools
      inetutils

      # crypto / tls
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
