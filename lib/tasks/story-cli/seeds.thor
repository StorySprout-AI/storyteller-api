# frozen_string_literal: true

require 'thor'

module StoryCLI
  class Seeds < Thor
    include Thor::Shell

    namespace 'story-cli:seeds'

    desc 'load', 'Runs all seed tasks'
    def load
      # Create Doorkeeper Applications
      if Doorkeeper::Application.count.zero?
        client_credentials = Rails.application.credentials.storysprout
        preset_credentials = if client_credentials.present?
                               {
                                 uid: client_credentials.client_id,
                                 secret: client_credentials.client_secret
                               }
                             else
                               {}
                             end
        Doorkeeper::Application.create(name: 'StorySprout', scopes: 'read write', **preset_credentials)

        say 'Doorkeeper Applications created', Color::GREEN
      else
        say 'Doorkeeper Applications already exist', Color::YELLOW
      end
    end
  end
end
