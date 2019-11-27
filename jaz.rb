class Jaz < Formula
  desc "Find secrets hidden in commits"
  homepage "https://github.com/jonaylor89/JAZ"
  url "https://github.com/jonaylor89/JAZ/archive/v0.0.2.tar.gz"
  sha256 "2474927a922c5e913d65473fd0f850eb09e8f6efaa5d553b99d6aa095f479054"

  if OS.mac?
    url "https://github.com/jonaylor89/JAZ/releases/download/v0.0.2/jaz"
    sha256 "32754b4173ac87a7bfffd436d601a49362676eb1841ab33440f2f49c002c8967"
  end

  def install
    bin.install "jaz"
  end

end
