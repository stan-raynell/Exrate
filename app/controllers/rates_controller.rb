class RatesController < ApplicationController
  def index
    @rate = Rate.last || Rate.new(value: "Курс не получен")
    if Rate.where(id: 1).present? and DateTime.current > @rate.end_date
      @current_rate = Rate.find(1).value
    else
      @current_rate = @rate.value
    end
  end

  def force
    @rate = Rate.new
  end

  def set
    Rate.get_rate
    @rate = Rate.new(params.fetch(:rate).permit(:end_date, :value))
    if @rate.save
      @current_rate = @rate.value
      respond_to do |format|
        format.html { redirect_to "/admin", notice: "Rate was created." }
        format.turbo_stream
      end
      redirect_to "/admin"
    else
      render :force, status: :unprocessable_entity
    end
  end
end
