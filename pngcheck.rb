class Pngcheck < Formula
  desc "Verify PNG file integrity and display chunk information"
  homepage "https://github.com/jonaylor89/pngcheck"
  url "https://github.com/jonaylor89/pngcheck/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "0aed1951795f3f21bd90ade7cf927686b6a63181c2b33a3d5d6b18dae2272621"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/pngcheck", "--help"
  end
end
