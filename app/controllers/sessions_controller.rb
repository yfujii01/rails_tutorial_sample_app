class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # ログイン成功

      log_in user

      redirect_to user

    else
      # ログイン失敗

      # flash[:danger] = 'Invalid email/password combination' # 本当は正しくない
      flash.now[:danger] = 'Invalid email/password combination'

      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

end
