# MessageQ

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'message_q'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install message_q

This Gem presently is focused on Sneakers and RabbitMQ integration but attempts to extract a lot of code into objects that could later be more de-decoupled to Sidekiq, ZeroMQ or whatever.

## Usage

ATM you must create intializers for Sneakers config,etc. 

This Gem is for `Consumer` worker processes that deserialize JSON into a `MessageQ::BaseMessage` subclass. The latter allows for simple validation hooks. 

### MessageQ::BaseMessage

This class is abstract and must be extended. It enforces the following required attributes:

* `uid` a non empty string
* `created_at` a 10 digit epoch timestamp

#### Extending MessageQ::BaseMessage

The tests have plenty of good examples. See `spec/support/test_klasses.rb`


### MessageQ::Consumer

Similar to the `BaseMessage`, this must be extended and is essential (at present) a `Sneakers::Worker` class with some sugar. Messages are automatically processed with a `MessageQ::BaseClass` subclass (you specify) and then a handler method is called `process_method` that you implement and use the `message` attribute to do your work. This is the actual `BaseMessage` type which has `to_hash` and `to_json` as well as accessors.

See source code for more info like above.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/message_q.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

