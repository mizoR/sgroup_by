# SgroupBy

Enumerator for streaming grouping.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sgroup_by'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install sgroup_by

## Usage

```rb
# Assumption that the data is grouped by the value of the first row of the CSV and that there is no bias in the data.

rows = CSV.foreach('./file-too-large-to-load-at-once.csv').extend(SgroupBy)

grouping = rows.sgroup_by {|row| row[0] }

grouping.each {|key, rows| p [key, rows.size] }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mizoR/sgroup_by.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
