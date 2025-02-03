class Figurine < Formula
  desc "Print your name in style"
  homepage "https://github.com/arsham/figurine"
  
  version "v1.3.0"
  url "https://github.com/arsham/figurine/archive/refs/tags/#{version}.tar.gz"
  sha256 "e969f4f9e617201fc92d5467c7af11578a4f3d1f025ad2110ee2c56a663cbdf0"
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