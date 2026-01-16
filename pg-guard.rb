class PgGuard < Formula
  desc "Postgres proxy with built-in safety features"
  homepage "https://github.com/jonaylor89/pg_guard"
  url "https://github.com/jonaylor89/pg_guard/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "37fa886a3b4e2c5c922f8b1765e64d72cf43cc69560f300844ea4579a427f1d0"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/pg_guard", "--help"
  end
end
