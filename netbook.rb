class Netbook < Formula
  desc "Lightweight TUI request collection manager and runner"
  homepage "https://github.com/jonaylor89/netbook"
  url "https://github.com/jonaylor89/netbook/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "fcee4240e490d21ee7739d6956d9362dbbb986a8d9ca5c2d5251a50acd6eb582"
  license "GPL-3.0-only"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/netbook", "--help"
  end
end
