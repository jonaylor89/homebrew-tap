class Ush < Formula
  desc "Ultrasonic shell for communicating between devices"
  homepage "https://github.com/jonaylor89/ush"
  url "https://github.com/jonaylor89/ush/archive/11fa97156e17135f9d80c21fb1f879fe11f29628.tar.gz"
  version "0.1.1"
  sha256 "fe7dae3942ce09059211c3c9e53b09658485c01ed471166949e56f81d86d94d7"
  license "GPL-3.0-only"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/ush", "--help"
  end
end
