# Bankscrap::Shinsei

[Bankscrap](https://github.com/bankscrap/bankscrap) adapter for Shinsei.

This adapter uses the Shinsei PowerDirect web interface and scraps Javascript
global variable values to get its data.

Contact: open an issue or email us at bankscrap@protonmail.com.

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

    $ bankscrap balance Shinsei --credentials=account:ACCOUNT_NUMBER password:PASSWORD pin:PIN security_grid=SECURITY_GRID

#### Transactions

    $ bankscrap transactions Shinsei --credentials=account:ACCOUNT_NUMBER password:PASSWORD pin:PIN security_grid:SECURITY_GRID

`SECURITY_GRID` must be provided in the format of lines, separated by commas.
Example:`1234567890,ABCDFEFGHI,JKLMNOPQRS,TUVWXYZ123`

---

For more details on usage instructions please read [Bankscrap readme](https://github.com/bankscrap/bankscrap/#usage).

### From Ruby code

```ruby
require 'bankscrap-shinsei'
shinsei = Bankscrap::Shinsei::Bank.new(account: ACCOUNT_NUMBER, password: PASSWORD, pin: PIN, security_grid: SECURITY_GRID)
```

## Contributing

1. Fork it ( https://github.com/bankscrap/bankscrap-shinsei/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Credits

[shinseibank-ruby](https://github.com/binzume/shinseibank-ruby) original scripts
were written by [@binzume](https://github.com/binzume), then [improved and
refactored to make a gem](https://github.com/knshiro/shinseibank-ruby) by
[@knshiro](https://github.com/knshiro) and
[@davidstosik](https://github.com/davidstosik).
