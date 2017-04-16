# frozen_string_literal: true
module Api::V2
  class UsersController < ::Api::UsersController
    before_action :authenticate_user, except: [:show, :create]
    before_action :set_user, only: [:show, :update]

    def show
      if @user.present?
        render json: @user
      else
        render json: {}, status: :not_found
      end
    end

    def update
      if @user.update(user_params)
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation,
                                   :locale)
    end

    def set_user
      @user = User.find_by(id: params[:id])
    end
  end
end
