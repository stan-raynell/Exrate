# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Root page" do
  let!(:current) { create(:rate, value: 100) }
  let!(:new) { create(:rate, value: 500, end_date: 5.days.ago) }

  it "should display current exchange rate" do
    visit root_path
    expect(page).to have_content(current.value)
  end

  it "should display forced unexpired rate" do
    new.end_date = 5.years.from_now
    new.save
    visit root_path
    expect(page).to have_content(new.value)
  end
end
