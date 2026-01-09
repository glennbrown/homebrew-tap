cask "ersatztv" do
  arch arm: "arm64", intel: "x64"

  version 26.1.1
  sha256 arm: "42d8ddada699279382947f5ea43434b202d78d663608dd5ae50a55a90bf69527",
         intel: "ba08372e33f872e0e1a117122b01688028860de864a16b06c62895b62625840d"

  url "https://github.com/ErsatzTV/ErsatzTV/releases/download/v#{version}/ErsatzTV-v#{version}-osx-#{arch}.dmg"
  name "ErsatzTV"
  desc "Open-source platform that transforms your personal media library into live, custom TV channels."
  homepage "https://ersatztv.org/"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on formula: "ffmpeg"

  app "ErsatzTV.app"

  zap trash: [
    "~/Library/Application Support/ErsatzTV",
  ]

end