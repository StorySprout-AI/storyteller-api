# frozen_string_literal: true

module TransactionalEmail
  class WelcomeEmailJob < ApplicationJob
    def perform(user_id)
      email = TransactionalEmail::Welcome.new(user_id:)
      email.send!
    end
  end
end
