class Forgedb < Formula
  desc "ForgeDB — an application database generator. Compiles a declarative .forge schema into tailored Rust database code, a TypeScript SDK, and a REST API."
  homepage "https://github.com/hoodiecollin/forgedb"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hoodiecollin/forgedb/releases/download/v0.2.1/forgedb-aarch64-apple-darwin.tar.xz"
      sha256 "f04a6a2a762dfe936c8021b362d3c164a70cc70f807769633ac67a03119b4657"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoodiecollin/forgedb/releases/download/v0.2.1/forgedb-x86_64-apple-darwin.tar.xz"
      sha256 "eec5564e75b859873412e72a73f4c5441c5f304be9654c03ba7d9baa7b2dff78"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hoodiecollin/forgedb/releases/download/v0.2.1/forgedb-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "638606c6ee09a1a0debae5fcb17ae17a556ba020b1fd07468a6ed832982dbb26"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoodiecollin/forgedb/releases/download/v0.2.1/forgedb-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e478eeed5b75e687506dc99ea32db7fadf3d4907b387bd7497dddcbc012acd71"
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
