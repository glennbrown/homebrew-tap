class Figurine < Formula
  desc "Print your name in style"
  homepage "https://github.com/arsham/figurine"
  
  # Use the latest release
  version = `git ls-remote --tags https://github.com/arsham/figurine.git | awk '{print $2}' | grep -v '{}' | sort -V | tail -n 1 | sed 's/refs\\/tags\\/v//'`.chomp
  url "https://github.com/arsham/figurine/archive/refs/tags/v#{version}.tar.gz"
  head "https://github.com/arsham/figurine.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"figurine", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/figurine --version")
  end
end