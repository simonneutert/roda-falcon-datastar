# frozen_string_literal: true

# # frozen_string_literal: true

require_relative 'db'

dev = ENV.fetch('RACK_ENV', 'development') == 'development'

DevDB.new.init(dev)
