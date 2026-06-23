class SettingsController < ApplicationController
  before_action :require_login

  def edit
  end

  def update
    if current_user.update(settings_params)
      redirect_to edit_settings_path, notice: '設定を保存しました'
    else
      flash.now[:alert] = current_user.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def settings_params
    params.require(:user).permit(:folder_distance_km)
  end
end
