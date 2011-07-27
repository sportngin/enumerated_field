require File.dirname(__FILE__) + '/test_helper'

class Apple
  include EnumeratedField

  attr_accessor :color, :kind
  
  enum_field :color, [['Red', :red], ['Green', 'green']]
  enum_field :kind, [['Fuji Apple', :fuji], ['Delicious Red Apple', :delicious]], :validate => false

  def initialize(color, kind)
    self.color = color
    self.kind = kind
  end

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

class EnumeratedFieldTest < Test::Unit::TestCase

  context 'EnumeratedField class' do

    should 'have the color_values method' do
      assert_equal Apple.color_values.length, 2
    end

    should 'have 2 values without first option' do
      assert_equal Apple.color_values.length, 2
    end

    should 'have 3 values with first option' do
      assert_equal Apple.color_values(:first_option => "Select Color").length, 3
    end

    should 'create contstants for the field keys' do
      assert_equal :chiquita, Banana::BRAND_CHIQUITA
      assert_equal :delmonte, Banana::BRAND_DELMONTE
    end

    should 'create underscored constants from field keys which contain invalid constant name characters' do
      assert_equal "great!", Banana::TASTINESS_GREAT_
      assert_equal "it's good", Banana::TASTINESS_IT_S_GOOD
      assert_equal "hate-hate", Banana::TASTINESS_HATE_HATE
    end
  end

  context 'EnumeratedField instance' do

    setup do
      @red_apple = Apple.new(:red, :fuji)
      @green_apple = Apple.new(:green, :delicious)
    end

    should 'have color_display method' do
      assert_equal @red_apple.color_display, 'Red'
    end

    should 'show Green for color_display of green' do
      assert_equal @red_apple.color_display_for(:green), 'Green'
    end

    should 'have two enum fields in one class' do
      assert_equal @green_apple.color_display, 'Green'
      assert_equal @green_apple.kind_display, 'Delicious Red Apple'
    end

    should 'have valid question methods' do
      assert @green_apple.color_green?
      assert !@green_apple.color_red?
      assert @green_apple.kind_delicious?
      assert !@green_apple.kind_fuji?
    end

    should 'have 2 values without first option' do
      assert_equal @red_apple.color_values.length, 2
    end

    should 'have 3 values with first option' do
      assert_equal @red_apple.color_values(:first_option => "Select Color").length, 3
    end

  end

  context 'Validation' do
    should 'occur by default' do
      # valid choice
      banana = Banana.new(:chiquita, :green)
      assert banana.valid?

      # invalid choice
      bad_banana = Banana.new(:penzoil, :orange)
      assert !bad_banana.valid?
      assert_equal ["is not included in the list"], bad_banana.errors[:brand]
      assert_equal ["is not included in the list"], bad_banana.errors[:color]

      # invalid choice (brand doesn't allow nil, color does)
      nil_banana = Banana.new(nil, nil)
      assert !nil_banana.valid?
      assert_equal ["is not included in the list"], nil_banana.errors[:brand]
      assert_equal [], nil_banana.errors[:color]
    end

    should 'not occur if passed :validate => false' do
      # no validations, accepts any choice
      apple = Apple.new(:orange, :macintosh)
      assert !apple.respond_to?(:valid)
    end

    should 'accept valid string equivalent to symbol in list' do
      banana = Banana.new('chiquita', :green)
      assert banana.valid?, banana.errors[:brand][0]
    end
  end
end
