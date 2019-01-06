require 'rexml/document'

class Roku::Iap::Response
  attr_accessor :raw_response #, :error_code, :error_details, :error_message, :status, :amount, :cancelled, :channel_id, :channel_name, :coupon_code, :currency, :expiration_date, :original_purchase_date, :partner_reference_id, :product_id, :product_name, :purchase_date, :quantity, :roku_customer_id, :tax, :total, :transaction_id

  def initialize(data)
    self.raw_response = REXML::Document.new(data)
    self.raw_response.root.each do |e|
      underscore = e.name.gsub(/::/, '/').gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').gsub(/([a-z\d])([A-Z])/, '\1_\2').tr('-', '_').downcase
      self.class.class_eval("attr_accessor :#{underscore}")
      send "#{underscore}=", e.text.nil? ? "" : e.text
    end
  end

  def successful?
     self.try(:status) == "Success"
  end

  def unauthorized?
    self.try(:error_message) == "UNAUTHORIZED"
  end

  protected

  def try(att)
    begin send "#{att}"; rescue NoMethodError ; end
  end
end