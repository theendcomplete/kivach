module Api
  module V1
    module Users
      class AuthsController < Api::V1::ApiController
        TOKENS_ITERATIONS_LIMIT = 10
        TOKENS_PER_USER_LIMIT = 5

        before_action :authorize_user, only: %i[show]
        before_action :init_user_token, only: %i[update destroy]

        def show
        end

        def create
          login = params[:login].downcase
          password = params[:password]

          raise Error::BadRequest, code: 'USERS_AUTH_PARAMS_LOGIN_MISSING' if login.blank?
          raise Error::BadRequest, code: 'USERS_AUTH_PARAMS_PASSWORD_MISSING' if password.blank?

          Session.user = User.where('email = ? OR login = ?', login, login).first
          raise Error::NotFound, code: 'USERS_AUTH_USER_NOT_FOUND' if Session.user.blank? || Session.user.auth_blocked_until&.future?

          unless Session.user.authenticate(password)
            Session.user.check_auth_attempt! request
            raise Error::NotFound, code: 'USERS_AUTH_USER_NOT_FOUND'
          end
          raise Error::Forbidden, code: 'USERS_AUTH_USER_BLOCKED' if Session.user.blocked?

          user_tokens = Session.user.user_tokens.order(updated_at: :asc)
          user_tokens.first.destroy if user_tokens.size > TOKENS_PER_USER_LIMIT

          token_coincidence_count = 0
          user_token = nil
          until user_token.present?
            begin
              user_token = UserToken.create!(
                user_id: Session.user.id,
                http_remote_addr: request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip,
                http_user_agent: request.headers['HTTP_USER_AGENT']
              )
            rescue ActiveRecord::RecordNotUnique
              token_coincidence_count += 1
              raise Error::InternalServerError, code: 'USERS_AUTH_TOKEN_NOT_CREATED' if token_coincidence_count > TOKENS_ITERATIONS_LIMIT
            end
          end

          Session.token = user_token[:token]
        end

        def update
          init_user_token
          @user_token.touch(:updated_at)
        end

        def destroy
          init_user_token
          @user_token.destroy
        end

        private

        def init_user_token
          @user_token = UserToken.find_by(token: Session.token)
          raise Error::Unauthorized if @user_token.blank?
        end
      end
    end
  end
end
