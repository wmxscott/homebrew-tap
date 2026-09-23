class ThemeMonitor < Formula
  desc "Write the macOS light/dark appearance to a file whenever it changes"
  homepage "https://github.com/wmxscott/theme-monitor"
  url "https://github.com/wmxscott/theme-monitor/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "51712660fb07d3c65a4a499d14468a84df461ce050a38dd35c31493a44a7a33e"
  license "MIT"
  head "https://github.com/wmxscott/theme-monitor.git", branch: "main"

  depends_on macos: :ventura

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/theme-monitor"
  end

  service do
    run opt_bin/"theme-monitor"
    keep_alive true
    process_type :background
    log_path var/"log/theme-monitor.log"
    error_log_path var/"log/theme-monitor.log"
  end

  test do
    assert_match "theme-monitor #{version}", shell_output("#{bin}/theme-monitor --version")
    assert_match(/\A(light|dark)\n\z/, shell_output("#{bin}/theme-monitor --print"))

    trigger = testpath/"trigger"
    pid = spawn bin/"theme-monitor", "--file", trigger
    begin
      20.times do
        break if trigger.exist? && !trigger.empty?

        sleep 0.25
      end
      assert_match(/\A(light|dark)\z/, trigger.read)
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
