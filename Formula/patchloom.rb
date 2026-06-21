class Patchloom < Formula
  desc "Structured file editing library and CLI for AI agents: parser-backed JSON/YAML/TOML edits, AST-aware code operations via tree-sitter, multi-file batching, markdown operations, and MCP server"
  homepage "https://patchloom.github.io/patchloom/"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.3.0/patchloom-aarch64-apple-darwin.tar.xz"
      sha256 "a592833359be8ac6e2cd304a446f43c9b78dec390a7f3cf026a6feba17d9c306"
    end
    if Hardware::CPU.intel?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.3.0/patchloom-x86_64-apple-darwin.tar.xz"
      sha256 "d0170e10a51ff83f413b296f69ba423e4e448f2eeb0285d0e2092c2326804f74"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.3.0/patchloom-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "594b2f838192ff5246ca9416f83cf08d5bf404cb71c76ce81fda156beecc9d8f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.3.0/patchloom-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "173934385007509379e8df1b49b946837fc32a4d9cb43d8738d4f92143067e9b"
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
