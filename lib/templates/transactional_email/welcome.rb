# frozen_string_literal: true

module TransactionalEmail
  # Template sharing URL: https://my.brevo.com/template/3Tpg_IlAnA_RtXDSJ5_X2KXI1LfSU9wDKCtzn0JhM773maaiyc.MAtU3
  class Welcome
    # TODO: Include support for GlobalID
    def initialize(email: nil, name: nil, user_id: nil)
      @user = User.find_by_id(user_id) unless user_id.nil?
      @recipients ||= []

      if @user.present?
        @recipients << SibApiV3Sdk::SendSmtpEmailTo.new(
          name: @user.name, email: @user.email
        )
      end

      return unless @recipients.none?
      raise ArgumentError, 'Email address is required if user is unknown' if email.nil?

      @recipients << SibApiV3Sdk::SendSmtpEmailTo.new(name:, email:)
    end

    def send!
      # Docs https://github.com/sendinblue/APIv3-ruby-library/blob/master/docs/SendSmtpEmail.md
      email = SibApiV3Sdk::SendSmtpEmail.new(
        to: @recipients,
        templateId: self.class.template_id,
        params: { SHOW_SOCIAL_LINKS: false }
      )
      # Docs https://github.com/sendinblue/APIv3-ruby-library/blob/master/docs/TransactionalEmailsApi.md
      api_instance = SibApiV3Sdk::TransactionalEmailsApi.new
      # Docs https://github.com/sendinblue/APIv3-ruby-library/blob/master/docs/TransactionalEmailsApi.md#send_transac_email
      # Returns a boolean if the email is sent successfully
      api_instance.send_transac_email(email)
      Rails.logger.info "Sent welcome email to #{@recipients}"
    rescue SibApiV3Sdk::ApiError => e
      Rails.logger.error "#{log_prefix(__method__)} => #{e}"
    end

    def log_prefix(method_name)
      "#{self.class.name}##{method_name}"
    end

    def self.template_id
      1
    end
  end
end
