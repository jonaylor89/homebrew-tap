class FacebookTotem < Formula
  desc "Tool for extracting and analyzing Facebook post data"
  homepage "https://github.com/jonaylor89/facebook_totem"
  url "https://github.com/jonaylor89/facebook_totem/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "ad4a3ff9d9b49c2e5d9a2d7697c3bfb4c2a00b89538cfc6effeb30af9b4ded91"
  license "GPL-3.0-only"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/facebook_totem", "--help"
  end
end
