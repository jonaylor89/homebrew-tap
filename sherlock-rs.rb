class SherlockRs < Formula
  desc "Hunt down social media accounts by username across social networks"
  homepage "https://sherlockproject.xyz/"
  url "https://github.com/jonaylor89/sherlock-rs/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "07200e1693d309b0e2c614b51dd3a6a242af5d7306f67c9d092a64d4056b6052"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/sherlock", "--help"
  end
end
