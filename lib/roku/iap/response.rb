require 'time'
require 'rexml/document'

class Roku::Iap::Response
  attr_accessor :raw_response #, :error_code, :error_details, :error_message, :status, :amount, :cancelled, :channel_id, :channel_name, :coupon_code, :currency, :expiration_date, :original_purchase_date, :partner_reference_id, :product_id, :product_name, :purchase_date, :quantity, :roku_customer_id, :tax, :total, :transaction_id
  def initialize(data)
    self.raw_response = REXML::Document.new(data)
    self.raw_response.root.elements.each do |e|
      underscore = e.name.gsub(/::/, '/').gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').gsub(/([a-z\d])([A-Z])/, '\1_\2').tr('-', '_').downcase
      self.class.class_eval("attr_accessor :#{underscore}") unless respond_to?(underscore)
      instance_variable_set :"@#{underscore}", e.text.nil? ? "" : e.text
    end
  end

  def successful?
     self.try(:status) == "Success"
  end

  def unauthorized?
    self.try(:error_message) == "UNAUTHORIZED"
  end

  def quantity
    @quantity.to_i unless blank?(@quantity)
  end

  def is_entitled
    @is_entitled.to_s.casecmp('true').zero? unless blank?(@is_entitled)
  end

  def amount
    @amount.to_f unless blank?(@amount)
  end

  def expiration_date
    parse_date(@expiration_date) unless blank?(@expiration_date)
  end

  def original_purchase_date
    parse_date(@original_purchase_date) unless blank?(@original_purchase_date)
  end

  def purchase_date
    parse_date(@purchase_date) unless blank?(@purchase_date)
  end

  protected

  def try(att)
    begin send "#{att}"; rescue NoMethodError ; end
  end

  def blank?(value)
    value.nil? || value.size == 0
  end

  def parse_date(date)
    # Roku responds with dates in UTC but without TZ marker
    date += 'Z' unless date.end_with?('Z')
    Time.parse(date)
  end
end