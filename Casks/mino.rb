cask "mino" do
  version "0.1.16"
  sha256 "e5b27603fe1e29bf02e79537134739876faa2ad60d8b2d73ece69ce51695511a"

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
