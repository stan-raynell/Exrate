# frozen_string_literal: true

class RatesController < ApplicationController
  def index
    @rate = Rate.last || Rate.new(value: "Курс не получен", end_date: 5.minutes.ago)
    return unless Rate.where(id: 1).present? && (DateTime.current > @rate.end_date)

    @rate = Rate.find(1)
  end

  def force
    @rate = Rate.new
  end

  def set
    Rate.get_rate
    @rate = Rate.new(params.fetch(:rate).permit(:end_date, :value))
    if DateTime.current < @rate.end_date
      if @rate.save
        PollRateJob.set(wait_until: @rate.end_date).perform_later
        Turbo::StreamsChannel.broadcast_update_to "rates",
                                                  target: "rates",
                                                  partial: "rates/rate",
                                                  locals: { rate: @rate }
        redirect_to "/admin"
      else
        render :force, status: :unprocessable_entity
      end
    end
  end
end
