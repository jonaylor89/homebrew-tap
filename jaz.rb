class Jaz < Formula
  desc "Find secrets hidden in commits"
  homepage "https://github.com/jonaylor89/JAZ"
  url "https://github.com/jonaylor89/JAZ/archive/refs/tags/v0.0.5.tar.gz"
  sha256 "1aae9606a15bc99109e3ba68016f7bb8b3ae0f5a01d05fa86a9bf65bba4103c7"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/jaz", "--help"
  end
end
