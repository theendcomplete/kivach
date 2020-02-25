module Api
  module V1
    module Users
      class ProfilesController < Api::V1::ApiController
        before_action :authorize_user
        before_action :init_user

        def show
        end

        def update
          User.transaction do
            if params[:password].present?
              params.require(%i[password_old password_confirmation])
              raise Error::BadRequest, code: 'USER_PROFILE_OLD_PASSWORD_INVALID' unless @user.authenticate(params[:password_old])
              raise Error::BadRequest, code: 'USER_PROFILE_NEW_PASSWORD_INVALID' if params[:password] == params[:password_old]
            end
            profile = params.permit(:first_name, :last_name, :password, :password_confirmation)
            @user.update!(profile)
            @user.notify_password_changed if params[:password].present?
          end
        end

        def destroy
          raise Error::Forbidden
        end

        private

        def init_user
          @user = Session.user
        end
      end
    end
  end
end
