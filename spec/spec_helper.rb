require "bundler/setup"
require "searching"
require "active_record"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

ActiveRecord::Base.establish_connection(
  adapter:   'sqlite3',
  database:  ':memory:'
)

class CreateAllTables < ActiveRecord::Migration[5.0]
  def self.up
    create_table :users do |t|
      t.string :name
      t.timestamps
    end

    create_table :posts do |t|
      t.references :user
      t.string :title
      t.timestamps
    end

    create_table :comments do |t|
      t.references :post
      t.string :body
      t.timestamps
    end
  end
end
CreateAllTables.up

class User < ActiveRecord::Base
  has_many :posts
end

class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
end

class Comment < ActiveRecord::Base
  belongs_to :post
end
