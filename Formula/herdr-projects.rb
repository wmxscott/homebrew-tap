class HerdrProjects < Formula
  desc "Curated project list that opens and labels Herdr workspaces"
  homepage "https://github.com/wmxscott/herdr-projects"
  url "https://github.com/wmxscott/herdr-projects/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "f8912c4e3ec8e3e05b0f77776439c2764e8d91fe398fe365efe5db84c4f54289"
  license "MIT"
  head "https://github.com/wmxscott/herdr-projects.git", branch: "main"

  depends_on "fzf"
  depends_on "python@3.14"

  def install
    libexec.install "bin", "lib"
    # The shim finds lib/ relative to its own path, and runs the first python3 on PATH.
    (bin/"herdr-projects").write_env_script libexec/"bin/herdr-projects",
                                            PATH: "#{formula_opt_bin("python@3.14")}:$PATH"
  end

  def caveats
    <<~EOS
      This installs the herdr-projects command. Install the Herdr plugin itself with:
        herdr plugin install wmxscott/herdr-projects
    EOS
  end

  test do
    assert_match "herdr-projects #{version}", shell_output("#{bin}/herdr-projects --version")

    # Stand-in herdr, so the test never talks to a real Herdr session.
    (testpath/"stub/herdr").write <<~SH
      #!/bin/sh
      echo "$*" >> "#{testpath}/herdr.log"
      case "$1 $2" in
        "workspace list") echo '{"result":{"workspaces":[]}}' ;;
        "pane list") echo '{"result":{"panes":[]}}' ;;
        *) exit 1 ;;
      esac
    SH
    chmod 0755, testpath/"stub/herdr"
    ENV["HERDR_BIN_PATH"] = testpath/"stub/herdr"
    ENV["HERDR_PLUGIN_CONFIG_DIR"] = testpath/"config"

    mkdir_p testpath/"src/api"
    mkdir_p testpath/"src/web"
    (testpath/"config/projects.toml").write <<~TOML
      [[groups]]
      name = "work"
      icon = "\\uf0b1"

      [[projects]]
      name = "api"
      group = "work"
      path = "#{testpath}/src/api"

      [[projects]]
      name = "notes"
      icon = "\\uf405"
      path = "#{testpath}/missing"
    TOML

    output = shell_output("#{bin}/herdr-projects list 2>&1")
    refute_match "no open/active status", output
    assert_match %r{^notes\t\S*/missing\tmissing$}, output
    assert_match %r{^work/api\t\S*/src/api\t-$}, output
    assert_match "workspace list", (testpath/"herdr.log").read

    assert_match "Added \uf0b1 work/web",
                 shell_output("#{bin}/herdr-projects add #{testpath}/src/web --group work")
    assert_match %r{^work/web\t\S*/src/web\t-$}, shell_output("#{bin}/herdr-projects list")
    shell_output("#{bin}/herdr-projects open nope", 1)
  end
end
