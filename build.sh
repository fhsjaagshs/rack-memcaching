#!/bin/sh

gem uninstall rack-memcaching
gem build rack-memcaching.gemspec
gem install --ignore-dependencies --local rack-memcaching-*.gem
