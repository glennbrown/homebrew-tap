class Soju < Formula
  desc "User-friendly IRC bouncer"
  homepage "https://soju.im"
  url "https://codeberg.org/emersion/soju/releases/download/v0.11.1/soju-0.11.1.tar.gz"
  sha256 "661151a5fbe1bb8ddc5a30ccd8616c8d54ae13a09a2cd68bc84ce4bce743babb"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://github.com/glennbrown/homebrew-tap/releases/download/soju-0.11.1"
    rebuild 1
    sha256 arm64_golden_gate: "69853a969da8d91875a4e493f788d4b6ee01267ade9159a5d227043a9faa6766"
    sha256 arm64_tahoe:       "8605745520130f0008c3173b8befc226f1c9a3bb5152df92b53d2e4ae1aac145"
    sha256 arm64_sequoia:     "5b65d3c3e7200fd6c94f09eb7127a50d33bcc3404caec4f8c5df0b43e88d6192"
    sha256 arm64_linux:       "7805485dec5d30167a0e1ee5d78c915b1c96546348231bcd39494ea50cc2b6b0"
    sha256 x86_64_linux:      "7cdd4cd74b2b3a0839a0a6d9cf183ee221467380b13ba7927557d469d7aa5029"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    system "make", "all",
           "GOFLAGS=-trimpath",
           "SYSCONFDIR=#{etc}",
           "RUNDIR=#{var}/run"

    bin.install "soju", "sojuctl", "sojudb"
    man1.install "doc/soju.1", "doc/sojuctl.1"

    (buildpath/"soju.conf").write <<~EOS
      db sqlite3 #{var}/lib/soju/main.db
      listen irc://localhost:6667
      listen unix+admin://#{var}/run/soju/admin
    EOS
    (etc/"soju").install "soju.conf" => "config"
  end

  post_install_steps do
    mkdir_p "lib/soju", base: :var
    mkdir_p "run/soju", base: :var
  end

  service do
    run opt_bin/"soju"
    keep_alive true
    working_dir var/"lib/soju"
    log_path var/"log/soju.log"
    error_log_path var/"log/soju.log"
  end

  def caveats
    <<~EOS
      Configuration: #{etc}/soju/config
      Database:      #{var}/lib/soju/main.db

      The default configuration only accepts plain-text connections from
      localhost. Add a "tls" directive and an ircs:// listener to the
      configuration before exposing soju to the network, then apply it with:
        brew services restart soju

      Create a user with:
        sojuctl user create -username <name> -admin
    EOS
  end

  test do
    port = free_port
    (testpath/"config").write <<~EOS
      db sqlite3 #{testpath}/main.db
      listen irc+insecure://127.0.0.1:#{port}
      listen unix+admin://#{testpath}/admin
    EOS

    pid = spawn bin/"soju", "-config", testpath/"config"
    begin
      sleep 2
      system bin/"sojuctl", "-config", testpath/"config", "user", "create",
             "-username", "test", "-password", "test"
      assert_path_exists testpath/"main.db"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
