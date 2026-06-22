class Patchloom < Formula
  desc "Structured file editing library and CLI for AI agents: parser-backed JSON/YAML/TOML edits, AST-aware code operations via tree-sitter, multi-file batching, markdown operations, and MCP server"
  homepage "https://patchloom.github.io/patchloom/"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.4.0/patchloom-aarch64-apple-darwin.tar.xz"
      sha256 "fbcedf1a982612d8b0e998e380de9359b2bf002b63eb41b9acb97ebbec8d14e6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.4.0/patchloom-x86_64-apple-darwin.tar.xz"
      sha256 "8cfd2da56c19438fa17b8a16a9097ee947e015878e860467dc34095c1ab32729"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.4.0/patchloom-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "68f5ea9084d71cba134b46603c9eab960be79d7860b7583985898363d0de6c21"
    end
    if Hardware::CPU.intel?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.4.0/patchloom-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "60771ae1aabcab9ba07fc5155cb0f0cc94787e3753693f6f74f8cf94a7f9a6a9"
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
