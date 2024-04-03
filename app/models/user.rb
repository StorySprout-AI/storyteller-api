# frozen_string_literal: true

class User < ApplicationRecord
  include UserState::CustomerJourney

  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :user_stories, dependent: :delete_all
  has_many :stories, through: :user_stories, dependent: :nullify

  validates :provider, presence: true
  validates :email,
            presence: true,
            # Docs on email validation: https://github.com/micke/valid_email2#use-with-activemodel
            'valid_email_2/email': true

  def admin?
    Rails.application.config.admin_emails.include? email
  end
end
