# frozen_string_literal: true

module UserState
  module CustomerJourney
    extend ActiveSupport::Concern

    included do
      include AASM

      aasm column: :customer_journey_state do
        state :new, initial: true
        # NOTE: Set existing customers to 👇🏾state to trigger their
        #   welcome email
        state :pending_onboarding
        # NOTE: Customers in 👇🏾state will not be able to access
        #   the app until :invite_to_soft_launch
        state :pending_soft_launch_invitation
        state :active
        state :inactive
        state :pending_request_to_delete

        event :finished_onboarding do
          transitions from: %i[new pending_onboarding], to: :active

          after do
            TransactionalEmail::WelcomeEmailJob.perform_later(id)
          end
        end

        event :invited_to_soft_launch do
          transitions from: %i[onboarded pending_soft_launch_invitation], to: :active
        end
      end
    end
  end
end
