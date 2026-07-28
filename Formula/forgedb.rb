class Forgedb < Formula
  desc "ForgeDB — an application database generator. Compiles a declarative .forge schema into tailored Rust database code, a TypeScript SDK, and a REST API."
  homepage "https://github.com/hoodiecollin/forgedb"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hoodiecollin/forgedb/releases/download/v0.2.0/forgedb-aarch64-apple-darwin.tar.xz"
      sha256 "aa2bb3ad4fc94ba4a25db96ec317322cafcb8aa7c237c95fa02104452cb46f20"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoodiecollin/forgedb/releases/download/v0.2.0/forgedb-x86_64-apple-darwin.tar.xz"
      sha256 "b5856d3c7c016e0ddf0bd96453e2b4ea4d78b5f25e9a365f0ad9ea98855eaa65"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hoodiecollin/forgedb/releases/download/v0.2.0/forgedb-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "72a4444206206f359c1a3ca69d6afbb4f6200ee6994a1472d6374a78bba0345a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoodiecollin/forgedb/releases/download/v0.2.0/forgedb-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3377cc82bd9ed60175f0de02187dd4dd4ea1b78a172cbd122d14743b92a6f529"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "forgedb", "forgedb-lsp" if OS.mac? && Hardware::CPU.arm?
    bin.install "forgedb", "forgedb-lsp" if OS.mac? && Hardware::CPU.intel?
    bin.install "forgedb", "forgedb-lsp" if OS.linux? && Hardware::CPU.arm?
    bin.install "forgedb", "forgedb-lsp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
