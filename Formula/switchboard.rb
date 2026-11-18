class Switchboard < Formula
  include Language::Python::Virtualenv

  desc "Keyboard-only tmux session switcher with coding agent state"
  homepage "https://github.com/wmxscott/switchboard"
  url "https://github.com/wmxscott/switchboard/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "4d1b2def7c3f674db1b762f43c84162d0ab161ae802f7c6834353825184750c4"
  license "MIT"
  head "https://github.com/wmxscott/switchboard.git", branch: "main"

  depends_on "fzf"
  depends_on "python@3.14"
  depends_on "tmux"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "switchboard #{version}", shell_output("#{bin}/switchboard --version")

    ENV.delete "TMUX"
    ENV.delete "TMUX_PANE"
    assert_empty pipe_output("#{bin}/switchboard hook Stop 2>&1", "", 0)
  end
end
