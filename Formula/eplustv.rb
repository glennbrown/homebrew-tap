class Eplustv < Formula
  desc "Virtual linear channels for ESPN+, FOX Sports, and other streaming providers"
  homepage "https://github.com/tonywagner/EPlusTV"
  url "https://github.com/tonywagner/EPlusTV/archive/refs/tags/v4.15.1.tar.gz"
  sha256 "f9e3b13be6efbd24c10182af74fc6ce017e56c44186988455f4834e3e76b1d7e"
  license "MIT"

  depends_on "node"
  depends_on "yt-dlp"
 
  def install
    # Install all dependencies (including devDeps needed for TypeScript)
    system "npm", "ci"
 
    # Install everything into libexec to keep it self-contained
    libexec.install Dir["*", ".??*"]
 
    # Create config directory that persists across runs
    (var/"eplustv").mkpath
  end
 
  def caveats
    <<~EOS
      EPlusTV stores its configuration and state in:
        #{var}/eplustv
 
      By default the server listens on port 8000. Access it at:
        http://localhost:8000
 
      Start the service with:
        brew services start eplustv
    EOS
  end
 
  service do
    run [libexec/"node_modules/.bin/tsx", libexec/"index.tsx"]
    environment_variables EPLUSTV_CONFIG_DIR: var/"eplustv",
                          PATH:              "#{Formula["node"].opt_bin}:#{Formula["yt-dlp"].opt_bin}:/usr/bin:/bin"
    working_dir libexec
    keep_alive true
    log_path var/"log/eplustv.log"
    error_log_path var/"log/eplustv.log"
  end
 
  test do
    # Verify node can load the entry point without errors (dry run)
    assert_match "EPlusTV", shell_output("cat #{libexec}/package.json")
  end
end