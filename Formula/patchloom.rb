class Patchloom < Formula
  desc "A Rust CLI for agent-grade repo operations"
  homepage "https://github.com/patchloom/patchloom"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/patchloom/patchloom/releases/download/v0.1.0/patchloom-aarch64-apple-darwin.tar.xz"
      sha256 "113d9bb8d19bf6e4a18e3effdbfd6bd4267acda15dfaedd95aebd2407d75af49"
    end
    if Hardware::CPU.intel?
      url "https://github.com/patchloom/patchloom/releases/download/v0.1.0/patchloom-x86_64-apple-darwin.tar.xz"
      sha256 "d170110805766fda7008233a2441e6db9f7cf09ce4b4fe018a19aec4b815c69c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/patchloom/patchloom/releases/download/v0.1.0/patchloom-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "18839b131d250b0adc91591bb8a97e68539bc4c5fe8f300e5aff9fe0c004c451"
    end
    if Hardware::CPU.intel?
      url "https://github.com/patchloom/patchloom/releases/download/v0.1.0/patchloom-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9035a51125f918475621d07400cc0979d3305806110ffbc9da20c387ea80fee3"
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
