# Tabherd: a dashboard for your coding agents.
# https://github.com/tleeadams/tabherd
class Tabherd < Formula
  desc "Dashboard for your coding agents"
  homepage "https://github.com/tleeadams/tabherd"
  url "https://github.com/tleeadams/tabherd/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "24472b95ac50756a8a3273bda688e3cdac03246b732cf5fef9e37be8f203eca0"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/tleeadams/homebrew-tap/releases/download/tabherd-0.6.1"
    sha256 cellar: :any_skip_relocation, all: "38c2dee107b1d3cca0a19950bd5bca823fcba9eeceb7f3ab7bc9bae757ad6210"
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
