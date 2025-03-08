class CertbotDnsCloudflare < Formula
    include Language::Python::Virtualenv
    
    desc "Cloudflare DNS authentication plugin for certbot"
    homepage "https://certbot.eff.org/"
    url "https://files.pythonhosted.org/packages/5a/3c/8c379fe3c55fca6a5e55bc9c58e54d5f0c8c9e4d34d6cd94c39dcd7a2af4/certbot-dns-cloudflare-2.8.0.tar.gz"
    sha256 "90faa2e869b7481e34977c0e5c9a52945f6b0a4cff2664cec2f339e54cb69bce"
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