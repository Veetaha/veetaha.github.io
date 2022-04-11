#!/usr/bin/env bash
set -eu -o pipefail

curl \
--retry 5 \
--retry-connrefused \
--retry-delay 30 \
-L https://github.com/Michael-F-Bryan/mdbook-linkcheck/releases/download/v0.7.4/mdbook-linkcheck.v0.7.4.x86_64-unknown-linux-gnu.zip \
--output ./mdbook-linkcheck.zip

unzip -j mdbook-linkcheck.zip mdbook-linkcheck -d /usr/local/bin
chmod +x /usr/local/bin/mdbook-linkcheck

curl \
--retry 5 \
--retry-connrefused \
--retry-delay 30 \
-L https://github.com/rust-lang/mdBook/releases/download/v0.4.3/mdbook-v0.4.3-x86_64-unknown-linux-gnu.tar.gz \
| tar -C /usr/local/bin -xzf -
