class Patchloom < Formula
  desc "A Rust CLI for agent-grade repo operations"
  homepage "https://github.com/patchloom/patchloom"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.1.5/patchloom-aarch64-apple-darwin.tar.xz"
      sha256 "c9ab7f5d28fa2c7d1c22fbd0c589ea5728b468ee49ceb844623598e63b8ff5ec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.1.5/patchloom-x86_64-apple-darwin.tar.xz"
      sha256 "594dd364840d196ce24e303d74e7bc8c94f628aa10894d62a8b3f0993c8754c1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.1.5/patchloom-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e64cadb5abc7075e3acc76877adc6cfc5eb9f14a40c4f4cde98b49db3d16881c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.1.5/patchloom-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "73a727aadc1e229ecb487cfa0ff325baf913003fccb7fc1a0e48fc50f5e61846"
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
