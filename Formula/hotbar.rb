class Hotbar < Formula
  include Language::Python::Virtualenv

  desc "Keyboard toolbar for tmux that opens your tools in popups"
  homepage "https://github.com/wmxscott/hotbar"
  url "https://github.com/wmxscott/hotbar/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "37cdb078d6198a66c7d8317236b77a4a66c4d8d24310e404242444d3e0e2088a"
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
