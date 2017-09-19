# Bankscrap::Shinsei

[Bankscrap](https://github.com/bankscrap/bankscrap) adapter for Shinsei.

**TODO**: write a proper description for your adapter.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bankscrap-shinsei'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bankscrap-shinsei

## Usage

### From terminal
#### Bank account balance

    $ bankscrap balance Shinsei --credentials=user:YOUR_USER --password:YOUR_PASSWORD --any_other_credential:ANY_OTHER_CREDENTIAL


#### Transactions

    $ bankscrap transactions Shinsei --credentials=user:YOUR_USER --password:YOUR_PASSWORD --any_other_credential:ANY_OTHER_CREDENTIAL

---

For more details on usage instructions please read [Bankscrap readme](https://github.com/bankscrap/bankscrap/#usage).

### From Ruby code

```ruby
require 'bankscrap-shinsei'
shinsei = Bankscrap::Shinsei::Bank.new(user: YOUR_USER, password: YOUR_PASSWORD, any_other_credential: ANY_OTHER_CREDENTIAL)
```


## Contributing

1. Fork it ( https://github.com/bankscrap/bankscrap-shinsei/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
