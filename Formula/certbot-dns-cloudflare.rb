class CertbotDnsCloudflare < Formula
    desc "Cloudflare DNS authentication plugin for certbot"
    homepage "https://certbot.eff.org/"
    url "https://files.pythonhosted.org/packages/0f/e9/05135e07cba369a0e9b8983a55ef18d3fa3522241f5a2eb4eee330c4bff1/certbot_dns_cloudflare-3.2.0.tar.gz"
    sha256 "845bf474d51d1c6fc7060591b23a61b1ec0ba72fb948457715abf6d59b513b18"
    license "Apache-2.0"
    
    depends_on "certbot"
    
    def install
      # Create a placeholder file in bin to satisfy Homebrew's expectations
      (bin/"certbot-dns-cloudflare-installed").write("Plugin installed to Certbot's environment")
      
      # Install plugin directly to Certbot's Python environment
      system "#{Formula["certbot"].opt_libexec}/bin/python", "-m", "pip", "install", "certbot-dns-cloudflare"
    end
    
    def caveats
      <<~EOS
        The certbot-dns-cloudflare plugin has been installed into Certbot's virtual environment.
        
        To use, create a credentials file with your Cloudflare API token:
        
          mkdir -p ~/.secrets/certbot/
          echo "dns_cloudflare_api_token = your-api-token" > ~/.secrets/certbot/cloudflare.ini
          chmod 600 ~/.secrets/certbot/cloudflare.ini
        
        Then use the plugin with:
        
          certbot certonly \\
            --dns-cloudflare \\
            --dns-cloudflare-credentials ~/.secrets/certbot/cloudflare.ini \\
            -d example.com \\
            -d "*.example.com"
      EOS
    end
    
    test do
      assert_match "dns-cloudflare", shell_output("#{Formula["certbot"].opt_bin}/certbot plugins --non-interactive")
    end
  end