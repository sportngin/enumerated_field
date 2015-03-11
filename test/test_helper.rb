require 'test/unit'
require 'turn'
require 'active_record'
require 'active_record/fixtures'
require 'yaml'
require 'sqlite3'
require 'enumerated_field'
require 'shoulda'
require 'shoulda/active_record'

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'
ActiveRecord::Schema.define do
  create_table :apples, :force => true do |t|
    t.string :color
    t.string :kind
  end
end

class Apple < ActiveRecord::Base
  include EnumeratedField

  enum_field :color, [['Red', :red], ['Green', :green]], :validate => false
  enum_field :kind, [['Fuji Apple', :fuji], ['Delicious Red Apple', :delicious]], :validate => false
end

class Banana
  include EnumeratedField
  include ActiveModel::Validations

  attr_accessor :brand
  attr_accessor :color
  attr_accessor :tastiness

  enum_field :brand, [["Chiquita", :chiquita], ["Del Monte", :delmonte]]
  enum_field :color, [["Awesome Yellow", :yellow], ["Icky Green", :green]], :allow_nil => true
  # stressing the constantizing of the keys
  enum_field :tastiness, [
    ["Great", "great!"],
    ["Good", "it's good"],
    ["Bad", "hate-hate"],
  ], :validate => false

  def initialize(brand, color)
    self.brand = brand
    self.color = color
  end
end

ActiveRecord::FixtureSet.create_fixtures 'test/fixtures', :apples
