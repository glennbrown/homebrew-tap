class CertbotDnsCloudflare < Formula
    include Language::Python::Virtualenv
    
    desc "Cloudflare DNS authentication plugin for certbot"
    homepage "https://certbot.eff.org/"
    url "https://files.pythonhosted.org/packages/0f/e9/05135e07cba369a0e9b8983a55ef18d3fa3522241f5a2eb4eee330c4bff1/certbot_dns_cloudflare-3.2.0.tar.gz"
    sha256 "845bf474d51d1c6fc7060591b23a61b1ec0ba72fb948457715abf6d59b513b18"
    license "Apache-2.0"
    
    depends_on "certbot"
    
    def install
      # Find the certbot installation
      certbot_path = Formula["certbot"].opt_libexec
      certbot_venv = File.dirname(certbot_path)
      
      # Create a script to install the plugin into Certbot's venv
      venv_installer = buildpath/"venv_installer.py"
      venv_installer.write <<~EOS
        #!/usr/bin/env python3
        import os
        import subprocess
        import sys
        
        certbot_venv = "#{certbot_venv}"
        plugin_path = "#{buildpath}"
        
        # Activate the virtual environment
        activate_this = os.path.join(certbot_venv, "bin", "activate_this.py")
        exec(compile(open(activate_this, "rb").read(), activate_this, 'exec'), {'__file__': activate_this})
        
        # Install the plugin and its dependencies
        subprocess.check_call([sys.executable, "-m", "pip", "install", "--no-deps", plugin_path])
        subprocess.check_call([sys.executable, "-m", "pip", "install", "cloudflare"])
      EOS
      
      # Install the plugin into Certbot's venv
      system "python3", venv_installer
      
      # Create a wrapper script
      bin.install_symlink certbot_path/"bin/certbot"
      
      # Create a README with usage instructions
      readme = buildpath/"README.md"
      readme.write <<~EOS
        # certbot-dns-cloudflare
        
        This formula installs the Cloudflare DNS authentication plugin for Certbot.
        
        ## Usage
        
        1. Create a Cloudflare API token with the following permissions:
           - Zone - DNS - Edit
           - Zone - Zone - Read
        
        2. Create a credentials file:
           ```
           mkdir -p ~/.secrets/certbot/
           echo "dns_cloudflare_api_token = your-api-token" > ~/.secrets/certbot/cloudflare.ini
           chmod 600 ~/.secrets/certbot/cloudflare.ini
           ```
        
        3. Request certificates:
           ```
           certbot certonly \\
             --dns-cloudflare \\
             --dns-cloudflare-credentials ~/.secrets/certbot/cloudflare.ini \\
             -d example.com \\
             -d "*.example.com"
           ```
      EOS
      
      # Install README
      doc.install readme
    end
    
    def post_install
      # Verify the plugin is installed correctly
      system "certbot", "plugins", "--non-interactive"
    end
    
    test do
      system "#{bin}/certbot", "plugins", "--non-interactive"
      assert_match "dns-cloudflare", shell_output("#{bin}/certbot plugins --non-interactive")
    end
  end