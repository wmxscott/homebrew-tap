class SeckeyDialog < Formula
  desc "Native macOS PIN, passphrase and touch prompts for gpg-agent and ssh"
  homepage "https://github.com/wmxscott/seckey-dialog"
  url "https://github.com/wmxscott/seckey-dialog/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "f911a88a6b2e99031ed311979a59584cf27de9c51de3e4127c46ca11be624a86"
  license "MIT"
  head "https://github.com/wmxscott/seckey-dialog.git", branch: "main"

  depends_on macos: :ventura

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/seckey-dialog"
  end

  def caveats
    <<~EOS
      For gpg-agent, add to ~/.gnupg/gpg-agent.conf:
        pinentry-program #{opt_bin}/seckey-dialog
      then run: gpgconf --kill gpg-agent

      For ssh, set these in ssh-agent's environment:
        SSH_ASKPASS=#{opt_bin}/seckey-dialog
        SSH_ASKPASS_REQUIRE=force

      Saving PINs in the keychain is off by default. Read this before turning it on:
        https://github.com/wmxscott/seckey-dialog/blob/main/SECURITY.md
    EOS
  end

  test do
    assert_match "seckey-dialog #{version}", shell_output("#{bin}/seckey-dialog --version")
    assert_match "SavePINs      off", shell_output("#{bin}/seckey-dialog settings")
    assert_match "D seckey-dialog", pipe_output(bin/"seckey-dialog", "GETINFO flavor\nBYE\n")
  end
end
