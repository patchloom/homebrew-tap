class Patchloom < Formula
  desc "Structured file editing library and CLI for AI agents: parser-backed JSON/YAML/TOML edits, AST-aware code operations, multi-file batching, markdown operations, and MCP server"
  homepage "https://patchloom.github.io/patchloom/"
  version "0.37.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.37.2/patchloom-aarch64-apple-darwin.tar.xz"
      sha256 "8283114c0ea3c91014ae7db98eeb720ccaee0119b7fbfaa7e083cacd4dfe1c35"
    end
    if Hardware::CPU.intel?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.37.2/patchloom-x86_64-apple-darwin.tar.xz"
      sha256 "8f140fbb6ddc035e8cd613b0676006b6f51e830e7157395ca27c9798434ac349"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.37.2/patchloom-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e4d8798575258f7bde2528b0b0f9ca90b66bcdd3ad11a72bd3846558480b785a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.37.2/patchloom-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "892bed4a5fc19a48f32cf7f969bc0388928c796bfb42c240ae2a9931a3983a26"
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
