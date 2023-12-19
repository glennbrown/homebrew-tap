class sshpass < Formula
    desc "Non-interactive ssh password authentication"
    homepage "https://sourceforge.net/projects/sshpass/"
    url "https://downloads.sourceforge.net/project/sshpass/sshpass/1.10/sshpass-1.10.tar.gz"
    sha256 "ad1106c203cbb56185ca3bad8c6ccafca3b4064696194da879f81c8d7bdfeeda"
    license "GPL-2.0-or-later"
  
    def install
      system "./configure", *std_configure_args, "--disable-silent-rules"
      system "make", "install"
    end

    def caveats
        <<~EOS
        SECURITY NOTE: 
        There is a reason openssh insists that passwords be typed interactively. Passwords are harder to store securely and to pass around securely between programs. 
        If you have not looked into solving your needs using SSH's "public key authentication", perhaps in conjunction with the ssh agent (RTFM ssh-add), please do so before being tempted into using this package.
        EOS
    end

    test do
      assert_match "ssh: Could not resolve hostname host: nodename nor servname provided, or not known",
        shell_output("#{bin}/sshpass -p mypassword ssh username@host touch foo 2>&1", 255)
  
      assert_match "sshpass #{version}", shell_output("#{bin}/sshpass -V")
    end
  end