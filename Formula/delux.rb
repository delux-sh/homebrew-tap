class Delux < Formula
  desc "Find existing tmux sessions across your computers and attach to them over SSH"
  homepage "https://github.com/delux-sh/delux"
  license "GPL-3.0-or-later"
  depends_on "tmux"

  on_macos do
    on_arm do
      url "https://github.com/delux-sh/delux/releases/download/v0.1.0/delux-0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "53768602d797ce15414ef4fa1764c63c4b9eae4745f4a1c8ea745447d1970a6f"
    end
    on_intel do
      url "https://github.com/delux-sh/delux/releases/download/v0.1.0/delux-0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "8f1d9b5b5e053147b86be8cab5f4cfc04a9402bbef0c5ade264ca67e21e40da5"
    end
  end

  on_linux do
    depends_on "openssh"

    on_arm do
      url "https://github.com/delux-sh/delux/releases/download/v0.1.0/delux-0.1.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "6279bd12b3e660a7567912e89be67e68c2272bf8f64fc3dd4fd019b41fe128c0"
    end
    on_intel do
      url "https://github.com/delux-sh/delux/releases/download/v0.1.0/delux-0.1.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "92f5a57689c10f47e0133bb87f3fbc59328f7755421103c3808210acc88bc1ac"
    end
  end

  def install
    bin.install "delux"
    doc.install "README.md", "LICENSE",
                "THIRD-PARTY-NOTICES.txt", "RUST-NOTICES.html", "MUSL-COPYRIGHT"
  end

  test do
    assert_match "delux #{version}", shell_output("#{bin}/delux --version")
    ENV.delete "TMUX"
    ENV.delete "TMUX_PANE"
    ENV["XDG_CONFIG_HOME"] = testpath/"config"
    ENV["XDG_STATE_HOME"] = testpath/"state"
    ENV["SHELL"] = "/bin/sh"
    # Homebrew's macOS sandbox permits Unix sockets inside testpath.
    ENV["TMUX_TMPDIR"] = testpath
    config = testpath/"tmux.conf"
    config.write "set -g default-shell /bin/sh\n"
    socket = "#{testpath}/tmux-#{Process.uid}/default"
    begin
      system "tmux", "-f", config, "new-session", "-d", "-s", "brew-test"
      inventory = JSON.parse(shell_output("#{bin}/delux list --local --json"))
      assert_equal ["brew-test"], inventory.fetch("computers").flat_map { |computer|
        computer.fetch("sessions").map { |session| session.fetch("name") }
      }
    ensure
      system "tmux", "-S", socket, "kill-server" if File.socket?(socket)
    end
  end
end
