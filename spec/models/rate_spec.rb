# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Rate model" do
  let!(:rate) { build(:rate) }
  let(:wrong) { build(:rate) }
  before(:all) do
    @cbr = Nokogiri::XML(URI.open("http://www.cbr.ru/scripts/XML_daily.asp"))
                   .xpath('//Valute[@ID="R01235"]/Value').text
  end

  it "should not allow to save empty rate" do
    expect(rate.save).to be_falsy
  end

  it "should validate value for numbers" do
    expect(wrong.save).to be_falsy
  end

  it "should allow to save proper value" do
    rate.value = 55
    expect(rate.save).to be_truthy
  end

  it "should get exchange rate from CBR" do
    Rate.get_rate
    expect(Rate.first.value).to eq(@cbr)
  end
end
