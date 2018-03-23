
# BocForex

This code provides access to recent foreign currency exchange data provided by the
Bank Of Canada via it's public [Valet API](https://www.bankofcanada.ca/valet/docs).


## Caveats 

This initial version works well enough for my current (corprate tax reporting) needs 
which is to generate forex gain/loss reports on aged invoices.  I cannot guarantee it
will work for you.

In particular, there are several caveats:

* queries to BOC are cached by year, which means that once you download forex 
  data for the current year, you are stuck with a data set that ends on whatever
  the previous business day is
* you will never be able to look up today's exchange rate
* exchange rates are available for BOC business days only
* the CLI could be a lot better

Plus, of course, the BOC Valet API may or may not be available at any given moment,
its function may change, or it may go away entirely.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'boc_forex'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install boc_forex

## Usage

### Command Line

```
    bocforex cad 2017-01-03
    bocforex cad 2017-01-03,2017-01-04,2017-01-05 aud,zar
```
*CURRENCIES* a comma separated list of currency codes.

*DATES* is a comma separated list of dates 


### API

```
   require 'boc_forex' 

   fxr = BocForex.Fetcher.forex_map( Date.new( 2017, 1, 3 ) )
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hzz/boc\_forex.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
