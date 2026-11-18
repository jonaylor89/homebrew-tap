cask "mino" do
  version "0.1.19"
  sha256 "88b1a3508c1d748d4bbcc85d8ac1c88e205e35416c92918b8a0e34953c41ad36"

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
