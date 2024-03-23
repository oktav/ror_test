# frozen_string_literal: true

module V1
  # UsersController
  class UsersController < V1::ApplicationController
    def check_status
      ip = '8.8.8.8'

      # Comment below to test
      ip = request.ip
      cf_ipcountry = request.headers['CF-IPCountry']

      ban_status = User.check_and_return_ban_status_name(
        cf_ipcountry:, ip:, idfa: params[:idfa], rooted_device: params[:rooted_device]
      )

      render json: { ban_status: }
    end
  end
end
