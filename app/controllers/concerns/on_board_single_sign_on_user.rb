# frozen_string_literal: true

class OnBoardSingleSignOnUser
  include Interactor

  after do
    context.user.finished_onboarding! unless context.user.active?
  end

  def call
    provider, name, image, email = context.to_h.values_at :iss, :name, :image, :email
    context.user = User.find_or_create_by(provider:, email:) do |user|
      user.name = name
      user.image = image
      user.email = email
      user.provider = provider
    end

    return unless context.user.errors.any?

    context.errors = context.user.errors.full_messages
    context.fail!(
      message: "There was a problem onboarding the user via #{provider.to_s.humanize} with email #{email}"
    )
  end
end
