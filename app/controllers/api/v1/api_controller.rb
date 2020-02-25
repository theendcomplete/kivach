module Api
  module V1
    class ApiController < ApplicationController
      before_action :init
      before_action :authorize_apikey

      def init
        Session.token = request.headers[:token]
      end

      def authenticate_user
        Session.user = User.with_token(Session.token).first if Session.token.present?
      end

      def authorize_user(role_codes = UserRole::CODES)
        raise Error::Unauthorized, code: 'USER_TOKEN_BLANK' if Session.token.blank?

        authenticate_user
        raise Error::Unauthorized, code: 'USER_TOKEN_NOT_FOUND' if Session.user.blank?
        raise Error::Forbidden, code: 'USER_NOT_AUTHORIZED' if Session.user.status_code == UserStatus::Blocked
        raise Error::Forbidden, code: 'USER_ACCESS_FORBIDDEN' unless role_codes.include?(Session.user.role_code)
      end

      def self.bootstrap(object_name)
        object_name = object_name.to_s.downcase.singularize
        model_name = object_name.split('_').map(&:capitalize).join
        begin
          model = Module.const_get(model_name)
          model.is_a?(Class)
        rescue NameError
          return
        end

        class_eval("before_action :init_#{object_name}, only: %i[show update destroy]", __FILE__, __LINE__)
        class_eval("before_action :init_#{object_name.pluralize}, only: %i[index]", __FILE__, __LINE__)

        define_method(:index) do
          var = "@#{object_name.pluralize}"
          instance_eval("#{var} = reduce_query(#{var})", __FILE__, __LINE__)
        end

        define_method(:show) do
        end

        define_method(:create) do
          var = "@#{object_name.singularize}"
          instance_eval("#{var} = #{model_name}.create!(create_params())", __FILE__, __LINE__)
        end

        define_method(:update) do
          var = "@#{object_name.singularize}"
          instance_eval("#{var}.update!(update_params())", __FILE__, __LINE__)
        end

        define_method(:destroy) do
          var = "@#{object_name.singularize}"
          instance_eval("#{var}.destroy!", __FILE__, __LINE__)
        end

        define_method(:create_params) do
          code = <<-CODE
            raise Error::NotImplemented, code: 'NOT_IMPLEMENTED' if CREATE_PARAMS.blank?
            params.permit(*CREATE_PARAMS)
          CODE
          instance_eval(code, __FILE__, __LINE__)
        end

        define_method(:update_params) do
          code = <<-CODE
            raise Error::NotImplemented, code: 'NOT_IMPLEMENTED' if UPDATE_PARAMS.blank?
            params.permit(*UPDATE_PARAMS) if UPDATE_PARAMS.present?
          CODE
          instance_eval(code, __FILE__, __LINE__)
        end

        define_method("get_#{object_name.pluralize}") do |args = {}|
          items = model.where(args)
          filter_method_name = "filter_#{object_name.pluralize}"
          items = send(filter_method_name, items) if respond_to?(filter_method_name, true)
          items
        end

        define_method("init_#{object_name.pluralize}") do |args = {}|
          var = "@#{object_name.pluralize}"
          instance_variable_set(var, send("get_#{object_name.pluralize}", args))
        end

        define_method("init_#{object_name}") do |args = {}|
          args = { id: instance_eval('params[:id]', __FILE__, __LINE__) }.merge(args)
          var = "@#{object_name}"
          instance_variable_set(var, public_send("get_#{object_name.pluralize}", args).first)
          instance_eval("raise Error::NotFound, code: '#{object_name.upcase}_NOT_FOUND' if #{var}.blank?", __FILE__, __LINE__)
        end
      end
    end
  end
end
