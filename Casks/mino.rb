cask "mino" do
  version "0.1.15"
  sha256 "c8080eac161795a94142e1256113f40cfc12444465aba846c5a6338c50037c6d"

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
