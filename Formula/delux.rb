class Delux < Formula
  desc "Find existing tmux sessions across your computers and attach to them over SSH"
  homepage "https://github.com/delux-sh/delux"
  license "GPL-3.0-or-later"
  depends_on "tmux"

  on_macos do
    on_arm do
      url "https://github.com/delux-sh/delux/releases/download/v0.3.0/delux-0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "c05a03f85d387b3a84eff558118d174055b0c6735bdc26ddf001032a47179151"
    end
    on_intel do
      url "https://github.com/delux-sh/delux/releases/download/v0.3.0/delux-0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "613bfe557e0dd95ecd492c086569fa9db742bed1d47d485ac58a6acefe4f49e7"
    end
  end

  on_linux do
    depends_on "openssh"

    on_arm do
      url "https://github.com/delux-sh/delux/releases/download/v0.3.0/delux-0.3.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "873c3c389a65be91207661e5d6360f67cb19b407c87c11d615fae14b4f667a8b"
    end
    on_intel do
      url "https://github.com/delux-sh/delux/releases/download/v0.3.0/delux-0.3.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "d1bae5d063f5bb7cfd85177369fa944aaddfca3a1b1575590e374ea2f28edf4e"
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
