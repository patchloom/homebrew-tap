class Patchloom < Formula
  desc "Structured file editing library and CLI for AI agents: parser-backed JSON/YAML/TOML edits, AST-aware code operations, multi-file batching, markdown operations, and MCP server"
  homepage "https://patchloom.github.io/patchloom/"
  version "0.16.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.16.0/patchloom-aarch64-apple-darwin.tar.xz"
      sha256 "b74dd4ce38f851173d1cf09805c477456ea8c5346fd99b4bf6854fc9cbc69e79"
    end
    if Hardware::CPU.intel?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.16.0/patchloom-x86_64-apple-darwin.tar.xz"
      sha256 "649f380397794f5904f340651847a7b36ebca7730f1805527c43f2414f93c63c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.16.0/patchloom-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ebbaa683297931b6cdb0e519d19487371b3b5c81d117e82be5dfdbcb1372d870"
    end
    if Hardware::CPU.intel?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.16.0/patchloom-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "faae88d68015dfff7fde24830c9b4a966f5074a054717d81681c6506149a47f8"
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
