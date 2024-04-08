class Proxmoxer < Formula
    include Language::Python::Virtualenv
  
    desc "Python wrapper for Proxmox RESI API v2."
    homepage "https://github.com/proxmoxer/proxmoxer"
    url "https://files.pythonhosted.org/packages/00/dd/629ec9dfdab26a75e3120403231bf3dc3ecda3ebe36db72c829ae30cbfca/proxmoxer-2.0.1.tar.gz"
    sha256 "088923f1a81ee27631e88314c609bfe22b33d8a41271b5f02e86f996f837fe31"
    license "GPL-3.0-only"
  
    depends_on "python@3.12"
    depends_on "python-requests"

    def install
      virtualenv_install_with_resources         
    end
  
  end
  