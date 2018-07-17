module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # ログインしているユーザー情報を返却する
  def current_user
    # User.find(session[:user_id])

    # 高速化
    # if @current_user.nil?
    #   @current_user = User.find_by(id: session[:user_id])
    # else
    #   @current_user
    # end

    # 単純化1
    # @current_user = @current_user || User.find_by(id: session[:user_id])

    # 単純化2
    @current_user ||= User.find_by(id: session[:user_id])

  end

  # ログインしているかをチェックする
  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
