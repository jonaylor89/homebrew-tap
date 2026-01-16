class Gitlocalstats < Formula
  desc "High-performance local contribution graph for Git and Jujutsu"
  homepage "https://github.com/jonaylor89/gitlocalstats"
  url "https://github.com/jonaylor89/gitlocalstats/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "b891d2390db33706ffd722211263c328f22d21a3d83072c04fac5006e647aee3"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/gitlocalstats", "--help"
  end
end
