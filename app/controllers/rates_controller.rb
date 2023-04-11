class RatesController < ApplicationController
  def index
    @rate = Rate.last || Rate.new(value: "Курс не получен")
    if Rate.where(id: 1).present? and DateTime.current > @rate.end_date
      @rate = Rate.find(1)
    end
  end

  def force
    @rate = Rate.new
  end

  def set
    Rate.get_rate
    @rate = Rate.new(params.fetch(:rate).permit(:end_date, :value))
    if @rate.save
      if DateTime.current < @rate.end_date
        Turbo::StreamsChannel.broadcast_update_to "rates", target: "rates", partial: "rates/rate", locals: { rate: @rate }
      else
        @current_rate = Rate.find(1)
        Turbo::StreamsChannel.broadcast_update_to "rates", target: "rates", partial: "rates/rate", locals: { rate: @current_rate }
      end
      redirect_to "/admin"
    else
      render :force, status: :unprocessable_entity
    end
  end
end
