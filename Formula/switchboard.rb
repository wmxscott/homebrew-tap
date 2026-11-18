class Switchboard < Formula
  include Language::Python::Virtualenv

  desc "Keyboard-only tmux session switcher with Claude Code agent state"
  homepage "https://github.com/wmxscott/switchboard"
  url "https://github.com/wmxscott/switchboard/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e5fcac4b3e5f56b71e93aff05ea048553cb4392bdefd83263430ec65174f14f6"
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
