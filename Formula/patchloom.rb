class Patchloom < Formula
  desc "A Rust CLI for agent-grade repo operations"
  homepage "https://github.com/patchloom/patchloom"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.1.6/patchloom-aarch64-apple-darwin.tar.xz"
      sha256 "bd8c2a7600e3490ee2a7c568405d38903d294ea2ba5e49ecfc550efd8edf046d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.1.6/patchloom-x86_64-apple-darwin.tar.xz"
      sha256 "7dab90b22cb3cceb4b71ee5b25cec894e7d9d12eb1e0667bbbbcb722b75cad22"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.1.6/patchloom-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3e5a2b32cd8a385f00d5ec1ba9ef4bba0d149b9596701e86a7ea22e84a977cd3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.1.6/patchloom-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c977ba3ca1c87fdbb59b20a1d7929377692e02c4fe50b36265aa8b5e5a217813"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "patchloom" if OS.mac? && Hardware::CPU.arm?
    bin.install "patchloom" if OS.mac? && Hardware::CPU.intel?
    bin.install "patchloom" if OS.linux? && Hardware::CPU.arm?
    bin.install "patchloom" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
