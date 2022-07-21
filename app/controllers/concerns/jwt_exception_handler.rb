module JwtExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from JWT::DecodeError do
      render json: { error: "Invalid Token. Please login again", error_code: "err01" }, status: :unauthorized
    end

    rescue_from JWT::ExpiredSignature do
      render json: { error: "Expired Token. Refresh Token or login again", error_code: "err02" }, status: :unauthorized
    end

    rescue_from JWT::EncodeError do
      render json: { error: "can't generate Token. Please login again", error_code: "err03" }, status: :unauthorized
    end

    rescue_from AuthHelper::WrongCredentialsError do
      render json: { error: "Invalid Credentials.", error_code: "err04" }, status: :unauthorized
    end

    rescue_from AuthHelper::RestrictedAccessError do
      render json: { error: "You don't have permission to access this resource", error_code: "err06" }, status: :forbidden
    end
  end
end
