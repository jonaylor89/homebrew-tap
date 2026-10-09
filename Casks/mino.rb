cask "mino" do
  version "0.1.14"
  sha256 "53860fc4681074d9cbeff22a23bc1f0b3232cb69a6afe58dbcb6421c99aa9db1"

  url "https://artifacts.mino.so/releases/v#{version}/Mino-#{version}.dmg"
  name "Mino"
  desc "Native, keyboard-driven email client"
  homepage "https://mino.so/"

  livecheck do
    url "https://artifacts.mino.so/releases/latest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  auto_updates true
  depends_on macos: :sonoma

  app "Mino.app"
end
