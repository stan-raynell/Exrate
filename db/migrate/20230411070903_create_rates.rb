# frozen_string_literal: true

class CreateRates < ActiveRecord::Migration[7.0]
  def change
    create_table :rates do |t|
      t.string :value
      t.datetime :end_date, default: 0

      t.timestamps
    end
  end
end
