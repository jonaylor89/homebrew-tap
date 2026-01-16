class Carbon14 < Formula
  desc "OSINT dating tool for web pages"
  homepage "https://github.com/jonaylor89/carbon14"
  url "https://github.com/jonaylor89/carbon14/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "9cdebf3f1444ee038525f83d8ebbb14e05962cd5076bf08cc94f3adb63569b6a"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/carbon_14", "--help"
  end
end
