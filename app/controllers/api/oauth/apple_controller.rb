# frozen_string_literal: true

# Sample project: https://github.com/nov/signin-with-apple
module Api
  module Oauth
    class AppleController < ApplicationController
      include Authorizable

      attr_accessor :token_response

      before_action :setup_provider_client, only: %i[create]
      before_action :authorize_client, only: %i[create]

      def index
        head :not_implemented
      end

      def token
        head :not_implemented
      end

      def create
        raise Errors::UnprocessableEntity unless params[:code].present? && params[:id_token].present?

        begin
          verify_back_channel_id_token!
          # TODO: I was getting an unauthorized error at this stage with "code has already been used".
          #   It seems that we are likely over-verifying the ID token. Feature flagging the FE verification
          #   for now since we only check the BE verification results downstream of this block
          verify_front_channel_id_token! if Flipper.enabled?(:feat__verify_front_channel_id_token)
        rescue AppleID::Client::Error => e
          puts e # gives useful messages from apple on failure
          raise Errors::Unauthorized
        end

        raise Errors::Unauthorized unless @id_token_back_channel&.aud == provider_credentials.client_id

        @id_token = @id_token_back_channel
        result = OnBoardSingleSignOnUser.call(id_token)
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
          :id_token,
          :client_id,
          :client_secret,
          :redirect_uri
        )
      end

      def id_token
        @id_token_back_channel.as_json&.with_indifferent_access
      end

      def verify_back_channel_id_token!
        id_token, code = params.values_at :id_token, :code
        return if id_token.nil? || code.nil?

        @provider_client.authorization_code = code
        @token_response = @provider_client.access_token!
        @id_token_back_channel = token_response.id_token
        @id_token_back_channel.verify!(
          client: @provider_client,
          access_token: token_response.access_token
        )
      end

      def verify_front_channel_id_token!
        return if params[:id_token].nil?

        @id_token_front_channel = AppleID::IdToken.decode(params[:id_token])
        @id_token_front_channel.verify!(client: @provider_client, code: params[:code])
      end

      def setup_provider_client
        @provider_client ||= AppleID::Client.new(
          identifier: provider_credentials.client_id,
          team_id: provider_credentials.team_id,
          key_id: provider_credentials.key_id,
          private_key: OpenSSL::PKey::EC.new(provider_credentials.key_pem),
          redirect_uri: params[:redirect_uri] || provider_credentials.redirect_uri
        )
      end

      def provider_credentials
        @provider_credentials ||= Rails.application.credentials.apple
      end

      def jwt
        private_key = OpenSSL::PKey::EC.new(provider_credentials.key_pem)
        header = { alg: 'ES256', kid: JWT::JWK.new(private_key)[:kid] }
        payload = {
          iss: provider_credentials.team_id,
          iat: Time.current.utc.to_i,
          exp: 2.weeks.from_now.utc.to_i,
          aud: 'https://appleid.apple.com',
          sub: provider_credentials.client_id
        }
        # https://developer.apple.com/documentation/sign_in_with_apple/generate_and_validate_tokens#3262048
        JWT.encode payload, private_key, 'ES256', header
      end
    end
  end
end
