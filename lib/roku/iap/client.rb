class Roku::Iap::Client
  require 'net/http'
  require 'uri'
  require 'json'

  PRODUCTION_HOST = "https://apipub.roku.com"

  def initialize(dev_token)
    @dev_token = dev_token 
    @host = PRODUCTION_HOST
  end

  def validate_transaction(transaction_id)
    path = "/listen/transaction-service.svc/validate-transaction/#{@dev_token}/#{transaction_id}"
    get_data(path)
  end

  def validate_refund(refund_id)
    path = "/listen/transaction-service.svc/validate-refund/#{@dev_token}/#{refund_id}"
    get_data(path)
  end

  def cancel_subscription(transaction_id, cancellation_date, partner_ref_id="")
    path = "/listen/transaction-service.svc/cancel-subscription"
    request_body_json = { 
      :partnerAPIKey => @dev_token,
      :transactionId => transaction_id,
      :cancellationDate => cancellation_date,
      :partnerReferenceId => partner_ref_id
    }.to_json
    post_data(path, request_body_json)
  end

  def refund_subscription(transaction_id, amount, partner_ref_id="", comments="")

    unless amount.match(/\d+/)
      # The Roku API returns 400 if amount is not parsable
      raise Roku::Iap::Exceptions::TypeError, "Ensure amount is integer or float!"
    end

    path = "/listen/transaction-service.svc/refund-subscription"
    request_body_json = {
      :partnerAPIKey => @dev_token,
      :transactionId => transaction_id,
      :amount => amount, 
      :partnerReferenceId => partner_ref_id,
      :comments => comments
    }.to_json
    post_data(path, request_body_json.to_s)
  end

  protected

  def get_data(path)
    uri = URI.parse "#{@host}#{path}"
    req = Net::HTTP::Get.new uri.request_uri
    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') { |http| http.request req }
    Roku::Iap::Response.new res
  end

  def post_data(path, request_body_json)
    uri = URI.parse "#{@host}#{path}"
    req = Net::HTTP::Post.new uri.request_uri
    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      req.content_type = "application/json"
      req.body = request_body_json
      http.request req
    end
    Roku::Iap::Response.new res
  end
end