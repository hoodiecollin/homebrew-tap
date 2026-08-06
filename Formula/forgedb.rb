class Forgedb < Formula
  desc "ForgeDB — an application database generator. Compiles a declarative .forge schema into tailored Rust database code, a TypeScript SDK, and a REST API."
  homepage "https://github.com/hoodiecollin/forgedb"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hoodiecollin/forgedb/releases/download/v0.3.2/forgedb-aarch64-apple-darwin.tar.xz"
      sha256 "ea2cc74d9f5ee30e432353b2e6f83ecc0c7f292c30b5b607921373faf1cc097f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoodiecollin/forgedb/releases/download/v0.3.2/forgedb-x86_64-apple-darwin.tar.xz"
      sha256 "65ca1b93f86b8c624acc841f48e427bb4a91a46683596eac2385a33f26fc5b0a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hoodiecollin/forgedb/releases/download/v0.3.2/forgedb-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3373787b70c3c5f280290d30899fefa62fb46ce9af15598698fd6838e5c4b978"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoodiecollin/forgedb/releases/download/v0.3.2/forgedb-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c515d794e6f1d566a888c994abd487a60f420af15f939b4fca9a96ac33a3cbb1"
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
