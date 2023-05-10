# frozen_string_literal: true

class Rate < ApplicationRecord
  validates :value, presence: true, format: { with: /\d+,?(\d+)?/ }
end
