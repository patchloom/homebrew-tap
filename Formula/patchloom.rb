class Patchloom < Formula
  desc "Structured file editing library and CLI for AI agents: parser-backed JSON/YAML/TOML edits, AST-aware code operations, multi-file batching, markdown operations, and MCP server"
  homepage "https://patchloom.github.io/patchloom/"
  version "0.37.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.37.4/patchloom-aarch64-apple-darwin.tar.xz"
      sha256 "12e8878631186d14d9f3ad061c3bc278233191b0317ed3453ee5daafb622f5a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.37.4/patchloom-x86_64-apple-darwin.tar.xz"
      sha256 "376100d7754e1516fc5621653ceb73df72922b353d526f664a3315d870010584"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.37.4/patchloom-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "215875c442a0799111775c92b8c9c386acbae68d114e2914b9149bd1eba97e14"
    end
    if Hardware::CPU.intel?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.37.4/patchloom-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1d28a7eb525e06f24e859fcb27b6fd9654140af59a55f6bc2dd9978a781f5639"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-pc-windows-gnu":             {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "patchloom"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "patchloom"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "patchloom"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "patchloom"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
