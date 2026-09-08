class Patchloom < Formula
  desc "Structured file editing library and CLI for AI agents: parser-backed JSON/YAML/TOML edits, AST-aware code operations, multi-file batching, markdown operations, and MCP server"
  homepage "https://patchloom.github.io/patchloom/"
  version "0.33.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.33.0/patchloom-aarch64-apple-darwin.tar.xz"
      sha256 "c8a0cbebae95a3851456136ac6fcf14d629778356f455b39050f69a7c921dc6e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.33.0/patchloom-x86_64-apple-darwin.tar.xz"
      sha256 "5b0bbf5cc9a61bd0f8a11c8f3587aa65476d9e14a94e0a90cec29a1eb679bc3b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.33.0/patchloom-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1c0b0318f971c7614a784cf758984ebe9a5ed0c8c51ea70ac5d7c3ce11342a49"
    end
    if Hardware::CPU.intel?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.33.0/patchloom-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7b26e1763e8fd5c0f60d4d961602694fe932d753d1ee348d4d04fd617514f444"
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
