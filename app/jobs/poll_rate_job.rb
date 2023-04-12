# frozen_string_literal: true

class PollRateJob < ApplicationJob
  queue_as :default

  def perform
    Rate.get_rate
    Turbo::StreamsChannel.broadcast_update_to "rates",
                                              target: "rates",
                                              partial: "rates/rate",
                                              locals: { rate: Rate.find(1) }
  end
end
