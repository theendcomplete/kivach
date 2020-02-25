module Api
  module V1
    class UsersController < ApiController
      before_action -> { authorize_user [UserRole::Admin] }, only: %i[create update destroy password import]
      before_action -> { authorize_user [UserRole::Admin, UserRole::Observer] }, only: %i[index show]

      before_action :init_user, only: %i[show update destroy]
      before_action :init_users, only: %i[index]

      PASSWORD_CHANGE_TIMEOUT = 5.minutes

      def index
        ids = []
        parse_param(:ids) { |value| ids += value }

        role_codes = []
        parse_param(:role_codes) { |value| role_codes += value }

        @users = @users.where(id: ids) if ids.present?
        @users = @users.by_role_codes(role_codes) if role_codes.present?

        @users = reduce_query(@users.accessible.distinct)
      end

      def show
      end

      def create
        User.transaction do
          @user = User.create!(user_params)
        end
      end

      def update
        User.transaction do
          @user.update!(user_params)
        end
      end

      def destroy
        User.transaction do
          @user.update!(status_code: UserStatus::Blocked)
        end
      end

      def password
        init_user params[:user_id]
        raise Error::Forbidden, code: 'PASSWORD_CHANGE_TOO_FAST' if @user.password_updated_at.present? && @user.password_updated_at.since(PASSWORD_CHANGE_TIMEOUT).future?

        @user.new_password!
      end

      def import
        User.create_or_update_from_csv(params[:file])
        head :created
      end

      private

      def init_user(id = params[:id])
        @user = User.accessible.where(id: id).first
        raise Error::NotFound, code: 'USER_NOT_FOUND' if @user.blank?
      end

      def init_users
        @users = User.all
      end

      def user_params
        valid_params = params.permit(
          :login, :email, :role_code, :status_code, :first_name, :last_name
        )
        valid_params
      end
    end
  end
end
