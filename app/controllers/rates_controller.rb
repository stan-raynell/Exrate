# frozen_string_literal: true

class RatesController < ApplicationController
  def index
    RateGetJob.perform_now if !Rate.last
    @rate = Rate.last
    return unless Rate.where(id: 1).present? && (DateTime.current > @rate.end_date)

    @rate = Rate.find(1)
  end

  def show
    RateGetJob.perform_later if !Rate.last
    @rate = Rate.new
  end

  def set_forced_rate
    @rate = Rate.new(params.fetch(:rate).permit(:end_date, :value))
    if DateTime.current < @rate.end_date
      if @rate.save
        RateCastJob.set(wait_until: @rate.end_date).perform_later
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
