# frozen_string_literal: true

class Rate < ApplicationRecord
  validates :value, presence: true, format: { with: /\d+,?(\d+)?/ }

  def self.get_rate
    @rate = Rate.find_by(id: 1) || Rate.new
    @rate.value = Nokogiri::XML(URI.open("http://www.cbr.ru/scripts/XML_daily.asp"))
                          .xpath('//Valute[@ID="R01235"]/Value').text
    @rate.end_date = 5.minutes.ago
    @rate.save
    if DateTime.current > Rate.last.end_date
      Turbo::StreamsChannel.broadcast_update_to "rates",
                                                target: "rates",
                                                partial: "rates/rate",
                                                locals: { rate: @rate }
    end
  end
end
