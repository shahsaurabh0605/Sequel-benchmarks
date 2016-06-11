require 'bundler/setup'
require 'sequel'
require_relative 'support/benchmark_rails'
Sequel::Database.connect(ENV.fetch('DATABASE_URL'))

COUNT=25 

Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      COUNT.times do |i|
        column :"column#{i}", "varchar(255)"
      end
    end
  end
end


class User < Sequel::Model; end

attributes = {}

COUNT.times do |i|
  attributes[:"column#{i}"] = "Some string #{i}"
end

Benchmark.rails("sequel/#{db_adapter}_create_string_columns", time: 5) do
  User.create(attributes)
end

