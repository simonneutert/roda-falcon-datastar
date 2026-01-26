# frozen_string_literal: true

dev = ENV.fetch('RACK_ENV', 'development') == 'development'

require 'bundler/setup'

require 'roda'
require 'sequel'
require 'extralite'
require 'logger'
require 'datastar'

require 'rack/unreloader'
Unreloader = Rack::Unreloader.new(
  logger: Logger.new($stdout),
  subclasses: ['Roda']
) { App }

require_relative 'db'

Unreloader.require './app.rb'
Unreloader.require './datastar_app.rb'

# Falcon forks, see the Sequel docs
# https://sequel.jeremyevans.net/rdoc/files/doc/fork_safety_rdoc.html#label-Other+Libraries+Calling+fork
Sequel::DATABASES.each(&:disconnect)

run(dev ? Unreloader : App)
