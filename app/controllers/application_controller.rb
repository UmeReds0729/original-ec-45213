class ApplicationController < ActionController::Base
  before_action :basic_auth
  before_action :configure_permitted_parameters, if: :devise_controller?

  private
  
  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
  end

  def normalize_name(name)
    return "" if name.blank?

    nkf = name.strip

    # 全角 → 半角、ひらがな → カタカナ
    nkf = nkf.tr('ぁ-ん','ァ-ン')
    nkf = nkf.tr('０-９ａ-ｚＡ-Ｚ','0-9a-zA-Z')

    nkf
  end
end
