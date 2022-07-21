class SessionsController < ApplicationController
  prepend_before_action :authenticate_user!, only: %i[index show destroy]

  def index
    @sessions = @current_user.sessions
    render jsonapi: @sessions, include: [:user]
  end

  def show
    if params[:id] == "current"
      render jsonapi: @current_session
    else
      render jsonapi: current_user.sessions.find(params[:id])
    end
  end

  def create
    username = params["username"]
    password = params["password"]
    ip = request.ip
    user_agent = request.user_agent

    login_data = AuthHelper.login(username, password, ip, user_agent)

    render json: { AccessToken:  login_data[:jwt],
                   RefreshToken: login_data[:refresh_token],
                   ExpireAt:     login_data[:exp] }
  end

  def update
    jwt = params["AccessToken"]
    refresh_token = params["RefreshToken"]
    ip = request.ip
    user_agent = request.user_agent

    login_data = AuthHelper.refresh(jwt, refresh_token, ip, user_agent)

    render json: { AccessToken:  login_data[:jwt],
                   RefreshToken: login_data[:refresh_token],
                   ExpireAt:     login_data[:exp] }
  end

  def destroy
    if params[:id] == "current"
      @current_session.update(logged_out: true)
    else
      @session = Session.find(params[:id])
      @session&.update(logged_out: true)
      render jsonapi: @session
    end
  end
end
