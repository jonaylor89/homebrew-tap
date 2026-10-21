cask "fuego" do
  version "1.0.1"
  sha256 "9da67027584d309a8ec1242209c6cb8a2861251e021f74a9f25a93904f5baf71"

  url "https://github.com/jonaylor89/jonaylor.com/releases/download/fuego-v#{version}/Fuego-#{version}.dmg",
      verified: "github.com/jonaylor89/jonaylor.com/"
  name "Fuego"
  desc "Menu bar focus timer that blocks distracting websites and apps"
  homepage "https://getfuego.dev/"

  livecheck do
    url "https://downloads.jonaylor.com/fuego/appcast.xml"
    strategy :sparkle
  end

  depends_on macos: :sequoia

  app "Fuego.app"

  uninstall quit: "dev.getfuego.FuegoFocus"

  zap trash: "~/Library/Preferences/dev.getfuego.FuegoFocus.plist"

  caveats <<~EOS
    Fuego blocks websites with a content filter that macOS asks you to approve
    the first time you start a focus session.

    `brew uninstall` leaves the content filter installed. Remove it in
    System Settings → General → Login Items & Extensions → Network Extensions.
  EOS
end
