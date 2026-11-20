# Homebrew tap for Tabherd

[Tabherd](https://github.com/tleeadams/tabherd) is a dashboard for your Claude Code sessions: which ones need you, which are working, and what they last said.

```
brew tap tleeadams/tap
brew install tabherd
```

Or in one line: `brew install tleeadams/tap/tabherd`. It works on macOS and Linux, with Homebrew's Node.

Then run `tabherd` to open the dashboard. `tabherd --install` adds Tabherd to Applications on macOS, or to the applications menu on Linux, and `tabherd --uninstall` removes it again. `brew upgrade` keeps it current.

A workflow here checks each day for a new Tabherd release and, once the formula installs and passes its test with it on macOS and Linux, updates the formula to it.

Tabherd is an independent project. It isn't made or endorsed by Anthropic.
