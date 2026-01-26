# frozen_string_literal: true

require 'sequel'
DB = Sequel.connect('extralite://app.db', wal: true)

# Helps initializing
class DevDB
  def init(dev) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    unless dev
      puts 'This action will drop the database! Sleeping for 30seconds.'
      sleep 30
    end

    begin
      if DB.tables.any?
        DB.drop_table :items
        puts "Dropping 'items' table"
      end
    rescue StandardError => e
      puts e
    end

    unless DB.tables.include? :items
      DB.create_table :items do
        primary_key :id
        String :name, unique: true, null: false
        Float :price, null: false
      end
    end

    # create a dataset from the items table
    items = DB[:items]
    # populate the table
    unless items.any?
      items.insert(name: 'abc', price: rand * 100)
      items.insert(name: 'def', price: rand * 100)
      items.insert(name: 'ghi', price: rand * 100)
    end
    puts items
  end
end
