class Toutatis < Formula
  desc "OSINT tool for gathering and analyzing public information"
  homepage "https://github.com/jonaylor89/toutatis"
  url "https://github.com/jonaylor89/toutatis/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "99614e8b469f946cd9add87467a05622ff5e5809497854060f1dc468606fa74e"
  license "GPL-3.0-only"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/toutatis", "--help"
  end
end
