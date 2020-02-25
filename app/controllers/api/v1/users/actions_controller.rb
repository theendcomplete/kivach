module Api
  module V1
    module Users
      class ActionsController < Api::V1::ApiController
        before_action :authorize_action_token, only: %i[show update]
        before_action :authorize_user, only: %i[create]

        def create
          @user.action_tokens.create!(type_code: params[:type_code])
        end

        def show
        end

        def update
          case @user_action_token.type_code.to_sym
          when :new_password
            raise Error::BadRequest, code: 'USERS_PARAMS_PASSWORD_INVALID' if @user_action_token.user.authenticate(params[:password])

            User.transaction do
              @user_action_token.user.update! params.permit(:password, :password_confirmation)
              @user_action_token.user.auth_tokens.destroy_all
              @user_action_token.destroy!
            end
          else
            raise Error::BadRequest, code: 'USER_ACTION_NOT_FOUND'
          end
        end

        private

        def authorize_user
          @user = User.where(login: params[:login]).or(User.where(email: params[:login])).first
          raise Error::BadRequest, code: 'USER_NOT_FOUND' if @user.blank?
          raise Error::Forbidden, code: 'USER_NOT_AUTHORIZED' if @user.status_code == UserStatus::Blocked
        end

        def authorize_action_token
          @user_action_token = UserActionToken.where(token: params[:token]).first
          raise Error::NotFound, code: 'USER_ACTION_TOKEN_NOT_FOUND' if @user_action_token.blank?
          raise Error::BadRequest, code: 'USER_ACTION_TOKEN_EXPIRED' if @user_action_token.expired?
        end
      end
    end
  end
end
