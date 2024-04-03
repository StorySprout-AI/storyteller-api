# frozen_string_literal: true

class AddCustomerJourneyStateToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :customer_journey_state, :string
  end
end
