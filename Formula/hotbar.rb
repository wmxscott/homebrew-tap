class Hotbar < Formula
  include Language::Python::Virtualenv

  desc "Keyboard toolbar for tmux that opens your tools in popups"
  homepage "https://github.com/wmxscott/hotbar"
  url "https://github.com/wmxscott/hotbar/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "b38729679368419501b75633e8e437af1058d1378c4f0c5e1c40674d0e62ce73"
  license "MIT"
  head "https://github.com/wmxscott/hotbar.git", branch: "main"

  depends_on "fzf"
  depends_on "python@3.14"
  depends_on "tmux"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "hotbar #{version}", shell_output("#{bin}/hotbar --version")
  end
end
