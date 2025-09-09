class CertbotDnsCloudflare < Formula
  include Language::Python::Virtualenv

  desc "Cloudflare DNS Authenticator plugin for Certbot"
  homepage "https://certbot.eff.org/"
  url "https://files.pythonhosted.org/packages/a9/96/6afc38a2f491b779f59cc547cd797dc2b6e0a2bca494a202732dc0029d20/certbot_dns_cloudflare-5.0.0.tar.gz"
  sha256 "84c01b06b2b0055f1b551eb3c0bc82c0a275063207cf9ea7ddc1b67129c728a4"
  license "Apache-2.0"

  depends_on "certbot"
  depends_on "python@3.13"
  depends_on "rust" => :build  # needed for cryptograp

  uses_from_macos "libffi"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/dc/67/960ebe6bf230a96cda2e0abcf73af550ec4f090005363542f0765df162e0/certifi-2025.8.3.tar.gz"
    sha256 "e564105f78ded564e3ae7c923924435e1daa7463faeab5bb932bc53ffae63407"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/eb/56/b1ba7935a17738ae8453301356628e8147c79dbb825bcbc73dc7401f9846/cffi-2.0.0.tar.gz"
    sha256 "44d1b5909021139fe36001ae048dbdde8214afa20200eda0f64c068cac5d5529"
  end
  
  resource "cloudflare" do
    url "https://files.pythonhosted.org/packages/9b/8f/d3a435435c42d4b05ce2274432265c5890f91f6047e6dab52e50c811a4ea/cloudflare-2.19.4.tar.gz"
    sha256 "3b6000a01a237c23bccfdf6d20256ea5111ec74a826ae9e74f9f0e5bb5b2383f"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/a7/35/c495bffc2056f2dadb32434f1feedd79abde2a7f8363e1974afa9c33c7e2/cryptography-45.0.7.tar.gz"
    sha256 "4b1654dfc64ea479c242508eb8c724044f1e964a47d1d1cacc5132292d851971"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    certbot = Formula["certbot"]

    venv = virtualenv_create(libexec, "python3.13")
    venv = virtualenv_create(certbot.libexec, "python3.13") # use certbot's venv

    # Install plugin into certbot's venv
    venv.pip_install resources
    venv.pip_install Pathname.pwd
  end

  test do
    # Verify the plugin is available to certbot
    assert_match "dns-cloudflare",
      shell_output("#{Formula["certbot"].bin}/certbot plugins")
  end
end
