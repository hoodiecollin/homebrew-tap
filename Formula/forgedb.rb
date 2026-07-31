class Forgedb < Formula
  desc "ForgeDB — an application database generator. Compiles a declarative .forge schema into tailored Rust database code, a TypeScript SDK, and a REST API."
  homepage "https://github.com/hoodiecollin/forgedb"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hoodiecollin/forgedb/releases/download/v0.3.0/forgedb-aarch64-apple-darwin.tar.xz"
      sha256 "143f73cf6911e01c262b7c1e48b1fb95435db83375c7cae2e6a3793475ca2e8b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoodiecollin/forgedb/releases/download/v0.3.0/forgedb-x86_64-apple-darwin.tar.xz"
      sha256 "10f0d342c620b04f4af742f3f8f0e9c7886f6990458980babf68a6cb9a12b67f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hoodiecollin/forgedb/releases/download/v0.3.0/forgedb-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7de83035cc009db83e1f402dc4d0403ee342b881deffc238585bdfda9abe581f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoodiecollin/forgedb/releases/download/v0.3.0/forgedb-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6fec41d6ef4a191f167f9881c14b1e7f2c92c5c829e022a15d90d3e9acee6466"
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
