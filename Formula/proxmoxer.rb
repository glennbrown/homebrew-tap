class Proxmoxer < Formula
    include Language::Python::Virtualenv
  
    desc "Python wrapper for Proxmox RESI API v2."
    homepage "https://github.com/proxmoxer/proxmoxer"
    url "https://files.pythonhosted.org/packages/5f/ab/4d0f98a25e3ff3e14a799a5d6d8fc99c03a51c1ec9cf4d33c028db20e92a/proxmoxer-2.9.0.tar.gz"
    sha256 "b777f34a4d9a6f997baa0b1e04d41e5a74d09a9b9321d7d9280a38cf11e2f1a5"
    license "GPL-3.0-only"
  
    depends_on "python@3.12"
    depends_on "python3-requests"

    resource "setuptools" do
        url "https://files.pythonhosted.org/packages/4d/5b/dc575711b6b8f2f866131a40d053e30e962e633b332acf7cd2c24843d83d/setuptools-69.2.0.tar.gz"
        sha256 "0ff4183f8f42cd8fa3acea16c45205521a4ef28f73c6391d8a25e92893134f2e"
      end

    def install
      virtualenv_install_with_resources         
    end
  
  end
  