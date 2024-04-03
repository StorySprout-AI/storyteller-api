# frozen_string_literal: true

require 'rails_helper'

# Doc on testing rails jobs: https://guides.rubyonrails.org/v7.0/testing.html#testing-jobs
describe TransactionalEmail::WelcomeEmailJob, type: :job do
  let!(:user) { FactoryBot.create(:user) }

  before do
    VCR.configure do |config|
      config.cassette_library_dir = 'spec/vcr_cassettes'
      config.hook_into :typhoeus, :faraday
    end
  end

  around do |example|
    VCR.use_cassette(
      'transactional_email/welcome_email_job',
      # NOTE: set the following line to :new_episodes to record new requests.
      #   Be sure to set BREVO_API_KEY in your .envrc file and run `direnv allow`
      #   to allow the environment variable to be used in the test before updating
      #   this configuration.
      record: :none
    ) do
      example.run
    end
  end

  context 'with a valid user' do
    it 'sends the welcome email' do
      described_class.perform_now(user.id)
    end
  end

  context 'with an invalid user' do
    it 'raises an error' do
      expect do
        described_class.perform_now(99)
      end.to raise_error(ArgumentError, /^Email address is required/)
    end
  end
end
