class Jaz < Formula
  desc "Find secrets hidden in commits"
  homepage "https://github.com/jonaylor89/JAZ"
  url "https://github.com/jonaylor89/JAZ/releases/download/v0.0.2/jaz"
  sha256 "589977f32f6ef7239dba6265aed03d2856c6f317942ed9baad386b0e4d4a6f1b"

  def install
    bin.install "jaz"
  end

end
