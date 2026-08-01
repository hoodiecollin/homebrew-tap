class Forgedb < Formula
  desc "ForgeDB — an application database generator. Compiles a declarative .forge schema into tailored Rust database code, a TypeScript SDK, and a REST API."
  homepage "https://github.com/hoodiecollin/forgedb"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hoodiecollin/forgedb/releases/download/v0.3.1/forgedb-aarch64-apple-darwin.tar.xz"
      sha256 "07dea8cb858d9b800cc9e3291ff94acb1b35d97a83d14b81fe9a612eb2f3a018"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoodiecollin/forgedb/releases/download/v0.3.1/forgedb-x86_64-apple-darwin.tar.xz"
      sha256 "d9c89312ac091d420342517b166ba6504def9811257994e677f9fc87969898f8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hoodiecollin/forgedb/releases/download/v0.3.1/forgedb-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f61cdf0add84d1ec23eed77f0f7f0a7a2829863b4621ec460c5ced57a81290b9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoodiecollin/forgedb/releases/download/v0.3.1/forgedb-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c2b19f23cbaa733dba4013c696e20096aa13fcfd24b30f8130f70cc158cfe081"
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
