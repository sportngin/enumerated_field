require File.dirname(__FILE__) + '/test_helper'

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

    should 'have the color_for_json method' do
      assert_equal Apple.color_for_json.length, 2
    end

    should 'show Red for first element display and equal red for value' do
      assert_equal Apple.color_for_json[0][:display], 'Red'
      assert_equal Apple.color_for_json[0][:value], :red
    end

  end

  context 'EnumeratedField instance' do

    setup do
      @red_apple = Apple.new(:color => :red, :kind => :fuji)
      @green_apple = Apple.new(:color => :green, :kind => :delicious)
    end

    should 'have color_display method' do
      assert_equal @red_apple.color_display, 'Red'
    end

    should 'show Green for color_display of green' do
      assert_equal @red_apple.color_display_for(:green), 'Green'
      assert_equal @red_apple.color_display_for('green'), 'Green'
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
      assert_equal @red_apple.color_values, [['Red', :red], ['Green', :green]]
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
      apple = Apple.new(:color => :orange, :kind => :macintosh)
      assert !apple.respond_to?(:valid)
    end

    should 'accept valid string equivalent to symbol in list' do
      banana = Banana.new('chiquita', :green)
      assert banana.valid?, banana.errors[:brand][0].to_s
    end
  end

  context 'ActiveRecord' do
    context 'instance' do
      subject { Apple.new }

      should have_db_column :color
      should have_db_column :kind
    end

    context 'class' do
      subject { Apple }

      should 'have scopes for each enumerated value' do
        assert_equal 4, subject.count
        ['color', 'kind'].each do |column|
          subject.send("#{column}_values").each do |a,b|
            assert subject.respond_to? "#{column}_#{b}"
            assert subject.send("#{column}_#{b}").any?
            assert_equal 2, subject.send("#{column}_#{b}").size
          end
        end
      end
    end
  end

end
