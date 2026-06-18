class Patchloom < Formula
  desc "Structured file editing library and CLI for AI agents: parser-backed JSON/YAML/TOML edits, multi-file batching, markdown operations, and MCP server"
  homepage "https://patchloom.github.io/patchloom/"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.2.0/patchloom-aarch64-apple-darwin.tar.xz"
      sha256 "19ce48ce48639c798db8b7c1d600a9fa392249305b0ae5597bd7ed50c2d2d89a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.2.0/patchloom-x86_64-apple-darwin.tar.xz"
      sha256 "206ad4a9f3db199e5457d87012d746e1f0133d59e2feb5ae5a198b11352e7109"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.2.0/patchloom-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a4a4eb7109694fe6d41ecf385a4c758616938d56ff20d38517e4b83c8e8fee5d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/patchloom/patchloom/releases/download/patchloom-v0.2.0/patchloom-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "03b6d834758b93a3511e52208f3c4a2704b91d560358fad695ea47c1ea43f198"
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
