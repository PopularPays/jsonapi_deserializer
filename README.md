# jsonapi_deserializer

[![Build Status](https://travis-ci.org/PopularPays/jsonapi_deserializer.svg)](https://travis-ci.org/PopularPays/jsonapi_deserializer) [![Dependency Status](https://gemnasium.com/PopularPays/jsonapi_deserializer.svg)](https://gemnasium.com/PopularPays/jsonapi_deserializer) [![Code Climate](https://codeclimate.com/github/PopularPays/jsonapi_deserializer/badges/gpa.svg)](https://codeclimate.com/github/PopularPays/jsonapi_deserializer)

Deserialize your [json-api](http://jsonapi.org/)
payloads into easy-to-use hashes
with attribute properties.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jsonapi_deserializer'
```

And then execute:

    $ bundle


## Usage

```ruby
response = {
  data: {
    type: 'dogs',
    id: '1',
    attributes: {
      name: 'fluffy'
    }
  }
}

one_deserialized = JSONApi::Deserializer.new(response).deserialized_hash
# one_deserialized.id == '1'
# one_deserialized.name == 'fluffy'
```

## Configuration

Version 1.3.1 introduces the ability to configure the gem using an initializer file and block with following options:

```
JSONApi::Deserializer.configure do |config|
  config.supports_lids = true
end
```

Above are all options for configuration with the default of each configuration option.

`supports_lids` - will include a `lid` key in each deserialized hash record. See JSONAPI spec '> 1.1' for more information on lids.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/popularpays/jsonapi_deserializer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

[MIT License](http://opensource.org/licenses/MIT)
