module EnumeratedField

  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods

    # ex. enum_field(:league, [['National Football League', :nfl], ['Major League Baseball', :mlb]])
    # field_name typically corresponds to the database column name
    # values_array is a double array (not a hash to preserve order for when order matters.. ie select options)    
    def enum_field(field_name, values_array)
      values_hash = {}
      values_array.each { |value, key| values_hash[key] = value }

      # returns the values_array for this field, useful for providing to
      # options_for_select when constructing forms
      enumerated_class = class << self; self; end
      enumerated_class.instance_eval do
        define_method("#{field_name}_values") do |*options|
          options = options.first || {}
          if options[:first_option]
            [[options[:first_option], '']] + values_array
          else
            values_array
          end
        end
      end

      class_eval do

        define_method("#{field_name}_values") do |*options|
          self.class.send("#{field_name}_values", *options)
        end

        # returns display value for the current value of the field
        define_method("#{field_name}_display") do
          values_hash[send(field_name)]
        end

        # returns display value for the given value of the field
        define_method("#{field_name}_display_for") do |key|
          values_hash[key]
        end

        define_method("#{field_name}_value_for") do |key|
          values_hash.invert[key]
        end

        # defines question methods for each possible value of the field
        # ex.  object.league_nfl?  which returns true if the objects league 
        # field is currently set to nfl otherwise false
        values_hash.keys.each do |key|
          define_method("#{field_name}_#{key}?") { send(field_name) == key }
        end

      end
    end

  end

end

