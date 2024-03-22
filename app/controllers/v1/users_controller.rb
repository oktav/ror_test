# frozen_string_literal: true

module V1
  # UsersController
  class UsersController < V1::ApplicationController
    def check_status
      request_ip = '8.8.8.8'

      # Comment below to test
      # request_ip = request.ip
      cf_ipcountry = request.headers['CF-IPCountry']

      ban_status = User.check_status(
        cf_ipcountry: cf_ipcountry,
        ip: request_ip,
        idfa: params[:idfa],
        rooted_device: params[:rooted_device]
      )

      render json: { ban_status: ban_status }
    end
  end
end
