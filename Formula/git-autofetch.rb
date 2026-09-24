class GitAutofetch < Formula
  include Language::Python::Virtualenv

  desc "Fetch git remotes in the background without surprise login prompts"
  homepage "https://github.com/wmxscott/git-autofetch"
  url "https://github.com/wmxscott/git-autofetch/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "69d73d35d5ba6417ac11f883a52b347507a7228b877c710da3b32e03444a579b"
  license "MIT"
  head "https://github.com/wmxscott/git-autofetch.git", branch: "main"

  depends_on :macos
  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  service do
    run [opt_bin/"git-autofetch", "run"]
    keep_alive true
    process_type :background
    log_path var/"log/git-autofetch.log"
    error_log_path var/"log/git-autofetch.log"
  end

  test do
    assert_match "git-autofetch #{version}", shell_output("#{bin}/git-autofetch --version")

    system "git", "init", "--quiet", "--bare", testpath/"origin.git"
    system "git", "clone", "--quiet", testpath/"origin.git", testpath/"work"
    (testpath/"config.toml").write <<~TOML
      [[repos]]
      path = "#{testpath}/work"
    TOML
    ENV["GIT_AUTOFETCH_CONFIG"] = testpath/"config.toml"
    ENV["XDG_STATE_HOME"] = testpath/"state"
    assert_match "ok", shell_output("#{bin}/git-autofetch fetch")
    assert_match "repositories:", shell_output("#{bin}/git-autofetch status")
  end
end
