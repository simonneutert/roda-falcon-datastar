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
DevDB.new.init(dev)

Unreloader.require './app.rb'
Unreloader.require './datastar_app.rb'

run(dev ? Unreloader : App)
