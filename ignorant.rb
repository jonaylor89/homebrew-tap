class Ignorant < Formula
  desc "Phone number OSINT tool for account discovery"
  homepage "https://github.com/jonaylor89/ignorant"
  url "https://github.com/jonaylor89/ignorant/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "9dd52a475e1472cb4f63c44ecedfd50e4362b2d7b6ab3dd9a8b2913757737b4f"
  license "GPL-3.0-only"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/ignorant", "--help"
  end
end
