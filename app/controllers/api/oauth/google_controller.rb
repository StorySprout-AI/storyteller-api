# frozen_string_literal: true

module Api
  module Oauth
    class GoogleController < ApplicationController
      include Authorizable

      before_action :authorize_client, only: [:create]
      before_action :verify_id_token, only: [:create]

      GOOGLE_AUTH_ERRORS = [
        Google::Auth::IDTokens::AudienceMismatchError,
        Google::Auth::IDTokens::ExpiredTokenError,
        Google::Auth::IDTokens::SignatureError
      ].freeze

      def index
        head :not_implemented
      end

      def create
        result = OnBoardSingleSignOnUser.call(@id_token)
        raise Errors::Unauthorized unless result.success?

        @user = result.user
        initialize_access_token!

        render json: {
          user: JSON.parse(@user.to_json),
          access_token: @access_token.token,
          refresh_token: @access_token.refresh_token,
          token_type: 'bearer',
          created_at: @access_token.created_at.to_i
        }, status: :created
      end

      private

      def auth_params
        params.permit(
          :credential,
          :client_id,
          :client_secret
        )
      end

      def verify_id_token
        payload = Google::Auth::IDTokens.verify_oidc(
          auth_params[:credential],
          aud: Rails.application.credentials.google.client_id
        )

        raise Errors::Unauthorized unless payload['aud'] == Rails.application.credentials.google.client_id

        @id_token = payload
      rescue *GOOGLE_AUTH_ERRORS
        head :unauthorized
      end
    end
  end
end
