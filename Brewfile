# frozen_string_literal: true

# Doc: https://github.com/Homebrew/homebrew-bundle

# set arguments for all 'brew install --cask' commands
cask_args appdir: '~/Applications', require_sha: true

# 'brew install'
brew 'imagemagick'
brew 'qpdf'
brew 'ruby-build'

# install only on specified OS
brew 'tree' if OS.mac?
brew 'gnutls' if OS.mac?
brew 'gnupg' if OS.mac?
brew 'glibc' if OS.linux?

# 'brew install --cask'
# cask "google-chrome"
cask 'ngrok' if OS.mac?
cask 'pgadmin4' if OS.mac?
