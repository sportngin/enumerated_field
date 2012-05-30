require "active_model"
require "active_support/hash_with_indifferent_access"

module EnumeratedField

  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods

    # ex. enum_field(:league, [['National Football League', :nfl], ['Major League Baseball', :mlb]])
    # field_name typically corresponds to the database column name
    # values_array is a double array (not a hash to preserve order for when order matters.. ie select options)
    def enum_field(field_name, values_array, options = {})
      values_hash = ActiveSupport::HashWithIndifferentAccess.new
      values_array.each { |value, key| values_hash[key] = value }
      default_options = {
        :validate => true,
        :allow_nil => false,
        :allow_blank => false,
      }
      options = default_options.merge(options)

      # returns the values_array for this field, useful for providing to
      # options_for_select when constructing forms
      enumerated_class = class << self; self; end
      enumerated_class.class_eval do
        define_method("#{field_name}_values") do |*options|
          options = options.first || {}
          if options[:first_option]
            [[options[:first_option], '']] + values_array
          else
            values_array
          end
        end

        define_method("#{field_name}_for_json") do
          values_array.map do |value, key|
            {:display => value, :value => key}
          end
        end
      end

      class_eval do

        unless options[:validate] == false
          valid_values = values_hash.keys
          values_hash.keys.map do |key|
            if key.is_a?(String) and not key.blank?
              valid_values << key.to_sym
            else
              valid_values << key.to_s
            end
          end
          validates field_name, :inclusion => valid_values,
            :allow_nil => options[:allow_nil], :allow_blank => options[:allow_blank]
        end

        values_array.each do |value, key|
          const_name = "#{field_name}_#{key}".upcase.gsub(/[^\w_]/, "_").to_sym
          const_set(const_name, key)
        end

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
          define_method("#{field_name}_#{key}?") { send(field_name).to_s == key.to_s }
        end

        if defined? ActiveRecord::Base and ancestors.include? ActiveRecord::Base
          values_hash.keys.each do |key|
            scope "#{field_name}_#{key}", where(field_name => key)
            scope "#{field_name}_not_#{key}", where(arel_table[field_name].not_eq(key))
          end
        end

      end
    end

  end

end

