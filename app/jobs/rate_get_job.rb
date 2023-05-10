# frozen_string_literal: true

class RateGetJob < ApplicationJob
  queue_as :default
  include Constants

  def perform
    @rate = Rate.find_by(id: 1) || Rate.new
    @rate.value = Nokogiri::XML(URI.open(URL)).xpath(USD).text
    @rate.end_date = 5.minutes.ago
    @rate.save
    if DateTime.current > Rate.last.end_date
      RateCastJob.perform_later
    end
  end
end
