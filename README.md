A simple Ruby client for the [Roku Web Service Api](http://sdkdocs.roku.com/display/sdkdoc/Web+Service+API).

## Installation

Add this line to your application's Gemfile:

    gem 'roku-iap'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install roku-iap

##Usage

Initialize a client with your Roku API key:

```ruby
client = Roku::Iap::Client.new 'roku_api_key'
```

Call any of the following methods (outlined in the Roku sdk docs):

```ruby
result = client.validate_transaction 'some-transaction-id'
result = client.validate_refund 'some-refund-id'
result = client.cancel_subscription 'some-tranasaction-id', 'cancellation_date', 'partner_ref_id'
result  = client.refund_subscription 'some-transaction-id', 'amount', 'partner_ref_id', 'comments'
```

## Response

The returned Roku::Iap::Response object has underscored attributes correlating to the xml returned by the Roku API. ```successful?``` can be called on the result to confirm that the response contains no errors.

```ruby
result = client.validate_transaction 'some-transaction-id'

if result.successful?
  puts result.amount          #"9.99"
  puts result.purchase_date   #"2014-11-03T00:07:23"
else
  puts result.error_message   #"Guid should contain 32 digits with 4 dashes (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)."
end
```

Non-200 status code responses will raise a Roku::Iap::Exceptions::General, and are distinct from errors returned by the Roku API (which you may call ```result.error_message``` to elaborate upon)

```ruby
begin
  result = client.validate_transaction 'some-transaction-id'
rescue Roku::Iap::Exceptions::General => e
  # enqueue to try again later
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b some-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin some-new-feature`)
5. Create new Pull Request