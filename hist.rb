class Hist < Formula
  desc "Quick way to make histograms that fix the terminal"
  homepage "https://github.com/jonaylor89/hist"
  url "https://github.com/jonaylor89/hist/archive/16edb63d3f40830b1904904727a4e654c2bb035f.tar.gz"
  version "0.1.3"
  sha256 "6695ebbc92e33312ae765e88b66f4f25e7550539aaceb4614d17a4b16effd496"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/v_hist"
  end
end
