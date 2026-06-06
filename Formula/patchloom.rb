class Patchloom < Formula
  desc "A Rust CLI for agent-grade repo operations"
  homepage "https://github.com/patchloom/patchloom"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.1.1/patchloom-aarch64-apple-darwin.tar.xz"
      sha256 "8c3dd7e8458b87d161b7dbb1936c0eea8fad96ee32cf9c009b371312a137d019"
    end
    if Hardware::CPU.intel?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.1.1/patchloom-x86_64-apple-darwin.tar.xz"
      sha256 "c410abd5ccc07cd577f615fa8bafe40af2b545033d68a4c2988117666437d7ae"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.1.1/patchloom-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "853e3b668d8faa49c1bf85c3cf2b28aa5a1812a1c7ffcebe174d6f244996a9ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.1.1/patchloom-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "80dc62b5f4ed3e26661a3b6108779e3f6db79529c48a74b8f07ee438bb480701"
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
