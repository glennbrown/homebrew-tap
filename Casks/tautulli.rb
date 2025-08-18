cask "tautulli" do

  version "2.15.3"
  sha256 "b5183bdfa31023861501c1437334726ffa281b54cf86bc60716ba0364d8bdfb0b5183bdfa31023861501c1437334726ffa281b54cf86bc60716ba0364d8bdfb0"

  url "https://github.com/Tautulli/Tautulli/releases/download/v#{version}/Tautulli-macos-v#{version}-universal.pkg"
  name "Tautulli"
  desc "A Python based monitoring and tracking tool for Plex Media Server."
  homepage "https://github.com/PowerShell/PowerShell"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on macos: ">= :mojave"

  pkg "Tautulli-macos-v#{version}-universal.pkg"

  uninstall pkgutil: "com.Tautulli.Tautulli"

  zap trash: [
    "~/Library/Application Support/Tautulli"
  ]

end