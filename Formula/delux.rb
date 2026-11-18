class Delux < Formula
  desc "Find existing tmux sessions across your computers and attach to them over SSH"
  homepage "https://github.com/delux-sh/delux"
  license "GPL-3.0-or-later"
  depends_on "tmux"

  on_macos do
    on_arm do
      url "https://github.com/delux-sh/delux/releases/download/v0.2.0/delux-0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "5991a513dbf7798b3f9fd2487ab27d2358d1543879c2255904a205b5c25cae4f"
    end
    on_intel do
      url "https://github.com/delux-sh/delux/releases/download/v0.2.0/delux-0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "7b45dc13bb8e6064eeab1c4be5842e361dd575a490120a0b93e2c136c4fd4c38"
    end
  end

  on_linux do
    depends_on "openssh"

    on_arm do
      url "https://github.com/delux-sh/delux/releases/download/v0.2.0/delux-0.2.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "00e4728df4fea513a22fe82cde07b46719dce14b1a5e43c5776cda7603f86294"
    end
    on_intel do
      url "https://github.com/delux-sh/delux/releases/download/v0.2.0/delux-0.2.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7937fec497e039c091ff724c4be3e583e5fbd2495202a22695cc132998f68d78"
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
