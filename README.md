EnumeratedField is a library that provides some nice methods when a
string column is used like an enumeration, meaning there is a list of
allowable values for the string column. Typically you want the display
value as seen by the end user to differ from the stored value, allowing
you to easily change the display value at anytime without migrating
data, and this little gem helps you with that.

## Usage

    enum_field(field_name, choices, options = {})

Available options are:

* `:validate`, whether to validate that the value is in the given list
  of choices. Defaults to true.
* `:allow_nil`, whether a nil value passes validation. Defaults to
  false.
* `:allow_blank`, whether a blank (nil, "") value passes validation.
  Defaults to false.

The default validation uses ActiveModel's inclusion validations. If
using on a class without ActiveModel use `:validate => false` to disable
these.

## Example

    class Hike < ActiveRecord::Base
      include EnumeratedField

      # default form
      enum_field :duration, [
        ['Short', 'short'],
        ['Really, really long', 'long']
      ]
      # disable default validation
      enum_field :trail, [
        ['Pacific Crest Trail', 'pct'],
        ['Continental Divide Trail', 'cdt'],
        ['Superior Hiking Trail', 'sht']
      ], :validate => false
    end

    > hike = Hike.create(:trail => 'pct', :duration => 'long')

### Confirm Values

    > hike.trail_sht?
    => false

    > hike.trail_pct?
    => true

    > hike.duration_long?
    => true

    > hike.duration_short?
    => false

### Display Selected Value

    > hike.trail_display
    => "Pacific Crest Trail"

    > hike.duration_display
    => "Really, really long"

### Validation

    > hike.valid?
    => true

    > hike.duration = 'forever'
    > hike.valid?
    => false

### List Available Values

    > hike.trail_values # useful to provide to options_for_select when constructing forms
    => [['Pacific Crest Trail', 'pct'], ['Continental Divide Trail', 'cdt'], ['Superior Hiking Trail', 'sht']]
    > Hike.trail_values # or get it from the class instead of the instance, if you like
    => [['Pacific Crest Trail', 'pct'], ['Continental Divide Trail', 'cdt'], ['Superior Hiking Trail', 'sht']]
    > Hike.trail_values_for_json # or get a has for injecting into JSON or wherever
    => [{:display => 'Pacific Crest Trail', :value => 'pct'}, {:display => 'Continental Divide Trail', :value => 'cdt'}, {:display => 'Superior Hiking Trail', :value => 'sht'}]

### ActiveRecord Scopes

These scopes are only created when your object is an ActiveRecord model.

    # performs Hike.where(:trail => Hike::TRAIL_CDT)
    > Hike.trail_cdt

    # performs Hike.where(:duration => Hike::DURATION_LONG)
    > Hike.duration_long

    # performs Hike.where(Hike.arel_table[:trail].not_eq(Hike::TRAIL_CDT))
    > Hike.trail_not_cdt

    # performs Hike.where(Hike.arel_table[:duration].not_eq(Hike::DURATION_LONG))
    > Hike.duration_not_long

### Use Constants for Keys

    > Hike::TRAIL_PCT
    => :pct
    > Hike::TRAIL_SHT
    => :sht

### Display Specified Value

    > hike.trail_display_for("sht")
    => "Superior Hiking Trail"

    > hike.duration_display_for("short")
    => "Short"

### Value for Specified Display

    > hike.trail_value_for("Superior Hiking Trail")
    => "sht"

    > hike.duration_value_for("Short")
    => "short"

These methods are all prefixed with the field name by design, which
allows multiple fields on a model to exist which potentially have the
same values.

## TESTS

Run tests with `bundle exec rake test` (or just `rake test` if you're
daring).

## TODO

* Provide any support needed for defining columns on MySQL databases as enum columns instead of string columns.

