require 'spec_helper'
require 'roku/iap/client'

describe Roku::Iap::Client do
  subject { described_class.new secret }

  let(:secret) { 'someSecret' }
  let(:transaction_id) { '12345' }

  context '.validate_transaction' do
    it 'calls the verify url' do
      stub = build_stub transaction_id
      subject.validate_transaction transaction_id

      expect(stub).to have_been_requested
    end

    it 'returns the result object' do
      response = build_response transaction_id
      build_stub transaction_id, 200, response

      result = subject.validate_transaction transaction_id

      expect(result.transaction_id).to eql(transaction_id)
      expect(result.purchase_date).to eql(Time.parse('2012-07-22T14:59:50Z'))
      expect(result.channel_name).to eql('123Video')
      expect(result.product_name).to eql('123Video Monthly Subscription')
      expect(result.product_id).to eql('NETMONTH')
      expect(result.amount).to eql(9.99)
      expect(result.currency).to eql('USD')
      expect(result.is_entitled).to eql(true)
      expect(result.quantity).to eql(1)
      expect(result.roku_customer_id).to eql('abcdefghijklmnop')
      expect(result.expiration_date).to eql(Time.parse('2012-08-22T14:59:50Z'))
      expect(result.original_purchase_date).to eql(Time.parse('2010-08-22T14:59:50Z'))
      expect(result.error_message).to eql('error_message')

      expect(result.raw_response.to_s).to eql(response)
    end

    it 'succeeds if unexpected key is returned' do
      response = unexpected_response
      build_stub transaction_id, 200, response

      result = subject.validate_transaction transaction_id

      expect(result.foo).to eql('bar')
    end

    it 'does not fail for parsed attributes when not present' do
      response = unexpected_response
      build_stub transaction_id, 200, response

      result = subject.validate_transaction transaction_id

      expect(result.purchase_date).to be nil
      expect(result.amount).to be nil
      expect(result.is_entitled).to be nil
      expect(result.quantity).to be nil
      expect(result.expiration_date).to be nil
      expect(result.original_purchase_date).to be nil
    end
  end


  def build_stub(transaction_id, status=200, response=nil)
    response = build_response transaction_id unless response

    stub_request(:get, url(transaction_id)).to_return(:body => response, :status => status)
  end

  def url(transaction_id)
    "https://apipub.roku.com/listen/transaction-service.svc/validate-transaction/#{secret}/#{transaction_id}"
  end

  def build_response(transaction_id)
    <<-XML
      <result>
        <transactionId>#{transaction_id}</transactionId>
        <purchaseDate>2012-07-22T14:59:50</purchaseDate>
        <channelName>123Video</channelName>
        <productName>123Video Monthly Subscription</productName>
        <productId>NETMONTH</productId>
        <amount>9.99</amount>
        <currency>USD</currency>
        <isEntitled>true</isEntitled>
        <quantity>1</quantity>
        <rokuCustomerId>abcdefghijklmnop</rokuCustomerId>
        <expirationDate>2012-08-22T14:59:50</expirationDate>
        <originalPurchaseDate>2010-08-22T14:59:50</originalPurchaseDate>
        <status>Success</status>
        <errorMessage>error_message</errorMessage>
      </result>
    XML
  end

  def unexpected_response
    <<-XML
      <result>
        <foo>bar</foo>
      </result>
    XML
  end
end
