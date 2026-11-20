#!/bin/sh
# Points the formula at a Tabherd release, and at its bottle when given one.
#
#   set-formula.sh <formula file> <tag> <source sha256> [<bottle sha256> <cellar>]
#
# The bottle is the one published as tabherd--<version>.all.bottle.tar.gz in
# this repository's release tabherd-<version>; "all" means one bottle for
# every macOS and Linux, which suits Tabherd: it's JavaScript and scripts.
set -e
export FILE="$1" TAG="$2" SOURCE="$3" BOTTLE="$4" CELLAR="$5"
export VERSION="${TAG#v}"
perl -0pi -e '
  s{^  url ".*"$}{  url "https://github.com/tleeadams/tabherd/archive/refs/tags/$ENV{TAG}.tar.gz"}m;
  s{^  sha256 "[0-9a-f]*"$}{  sha256 "$ENV{SOURCE}"}m;
  s{\n  bottle do\n.*?\n  end\n}{}s;
' "$FILE"
if [ -n "$BOTTLE" ]; then
  perl -0pi -e '
    s{(\n  license ".*"\n)}{$1\n  bottle do\n    root_url "https://github.com/tleeadams/homebrew-tap/releases/download/tabherd-$ENV{VERSION}"\n    sha256 cellar: :$ENV{CELLAR}, all: "$ENV{BOTTLE}"\n  end\n};
  ' "$FILE"
fi
