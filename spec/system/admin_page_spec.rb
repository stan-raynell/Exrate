# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin page" do
  let!(:current) { create(:rate, id: 1, value: 888) }
  let!(:set1) { create(:rate, value: 588, end_date: 5.days.ago) }
  let!(:set2) { create(:rate, value: 388, end_date: 5.days.from_now) }

  it "should allow to enter new rate" do
    visit "/admin"
    fill_in("Обменный курс", with: "90,80")
    click_on("Установить курс")
    expect(Rate.last.value).to eq("90,80")
  end
end
