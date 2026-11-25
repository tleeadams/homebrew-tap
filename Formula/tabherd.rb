# Tabherd: a dashboard for your Claude Code and Codex sessions.
# https://github.com/tleeadams/tabherd
class Tabherd < Formula
  desc "Dashboard for your Claude Code and Codex sessions"
  homepage "https://github.com/tleeadams/tabherd"
  url "https://github.com/tleeadams/tabherd/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "b7de5d412df103999eeb2c538ce90f6ae21e3794967b1434a8bb01416c0de355"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/tleeadams/homebrew-tap/releases/download/tabherd-0.5.0"
    sha256 cellar: :any_skip_relocation, all: "74f19d2eb3021e1db6ff76031eab12d5ef94a2c48442de0c2cb4596330f74c5b"
  end

  depends_on "node"

  def install
    libexec.install %w[server.js package.json lib public scripts launcher LICENSE README.md CHANGELOG.md]
    # Written again in post_install; this copy is what Homebrew links.
    (bin/"tabherd").write command_script
    chmod 0755, bin/"tabherd"
  end

  # The command and the launcher's Node hold paths to where Homebrew lives,
  # so they're made on this computer rather than taken from the bottle, which
  # serves every macOS and Linux. The launcher looks for Node in node/bin
  # beside the app, as a release download has it; here that's Homebrew's.
  def post_install
    rm_f bin/"tabherd"
    (bin/"tabherd").write command_script
    chmod 0755, bin/"tabherd"
    (libexec/"node/bin").mkpath
    ln_sf Formula["node"].opt_bin/"node", libexec/"node/bin/node"
  end

  def caveats
    <<~EOS
      Run `tabherd` to open the dashboard. To add Tabherd to Applications on
      macOS, or to the applications menu on Linux, run:
        tabherd --install
    EOS
  end

  test do
    output = shell_output("#{libexec}/node/bin/node #{libexec}/server.js --once")
    assert_match "running session(s)", output
  end

  private

  # Through opt/, so the command, and the app `tabherd --install` makes,
  # keep working after an upgrade.
  def command_script
    <<~SH
      #!/bin/sh
      exec "#{opt_libexec}/launcher/tabherd.sh" "$@"
    SH
  end
end
