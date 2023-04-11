class Rate < ApplicationRecord
  validates :value, presence: true, format: { with: /\d+\,?(\d+)?/ }

  # after_create_commit -> {
  #                       broadcast_replace_to "rates",
  #                                            target: "rates",
  #                                            partial: "rates/rate",
  #                                            locals: { rate: self }
  #                     }
  def self.get_rate
    @rate = Rate.find_by(id: 1) || Rate.new
    @rate.value = Nokogiri::XML(URI.open("http://www.cbr.ru/scripts/XML_daily.asp")).
      xpath('//Valute[@ID="R01235"]/Value').text
    @rate.save
  end
end
