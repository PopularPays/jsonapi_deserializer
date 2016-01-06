# jsonapi_deserializer

[![Build Status](https://travis-ci.org/PopularPays/jsonapi_deserializer.svg)](https://travis-ci.org/PopularPays/jsonapi_deserializer) [![Dependency Status](https://gemnasium.com/PopularPays/jsonapi_deserializer.svg)](https://gemnasium.com/PopularPays/jsonapi_deserializer)

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


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/popularpays/jsonapi_deserializer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

[MIT License](http://opensource.org/licenses/MIT)
