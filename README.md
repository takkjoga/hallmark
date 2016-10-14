# Hallmark

[![Build Status](https://travis-ci.org/takkjoga/hallmark.svg?branch=master)](https://travis-ci.org/takkjoga/hallmark)

This gem presents implementation required interface for Ruby

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hallmark'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hallmark

## Usage

```
# example interface class
class InterfaceClass
  def self.test1; end
  def self.test2(arg1, arg2 = nil, arg3: nil); end
  def test3; end
  def test4(arg1, arg2 = nil, arg3: nil); end
end

require 'hallmark'

class Test1
  hallmarked InterfaceClass # implementation required all methods 
end

class Test2
  hallmarked InterfaceClass, only: [:test2] # implementation required test2 singleton method
end

class Test3
  hallmarked InterfaceClass, except: [:test3] # implementation required all methods, except test3 instance method
end

class Test4
  hallmarked_instance_methods InterfaceClass, only: [:test4] # implementation required test4 instance method
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/takkjoga/hallmark. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

