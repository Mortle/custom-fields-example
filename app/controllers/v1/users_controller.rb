class V1::UsersController < ApplicationController
  before_action :set_user, only: %i[update]

  def update
    if @user.update(user_params)
      render json: @user.as_json(include: :custom_field_values), status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.includes(custom_field_values: { custom_field: :custom_field_options }).find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      custom_field_values_attributes: [
        :id,
        :custom_field_id,
        :value,
        :_destroy
      ]
    )
  end
end
