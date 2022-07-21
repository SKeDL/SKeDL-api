module JwtAuthenticatable
  extend ActiveSupport::Concern

  # include ActionController::HttpAuthentication::Token::ControllerMethods

  attr_accessor :current_session, :current_user

  def authenticate_user!
    pattern = /^Bearer /
    header = request.headers["Authorization"]
    jwt = header.gsub(pattern, "") if header&.match(pattern)
    raise AuthHelper::WrongCredentialsError unless jwt

    decoded_token = TokenHelper.decode_token(jwt)
    jti = decoded_token.first["jti"]
    @current_session = TokenHelper.session_from_valid_jti(jti)
    raise AuthHelper::WrongCredentialsError unless @current_session

    @current_user = @current_session&.user
  end

  def authenticate_admin!
    authenticate_user!
    raise AuthHelper::RestrictedAccessError unless @current_user&.admin?
  end
end
