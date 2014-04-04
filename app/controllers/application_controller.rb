class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :is_me?
  helper_method :is_authd?
  helper_method :head_title
  after_filter :save_lp

  helper_method :build_sl, :build_sl_link


  def handle_redirect
    redir = (session[:lp].nil?) ? root_path : session[:lp]
    session[:lp] = nil
    redirect_to redir, :notice => "Signed in!"
  end

  def show_404
    render "shared/404", status: 404
  end

  def head_title
    
    title = 'trog.de - Shorten dem URL\'S'
    if @page_title
      title = @page_title + ' | trog.de'
    end

    title
  end

  def build_sl(id)
    return "#{request.protocol}#{request.host_with_port}/#{id}"
  end

  def build_sl_link(id)
    link = build_sl(id)
    return view_context.link_to link, link, target: '_blank'
  end

  private

  def is_authd?
    return true if current_user
    return false
  end

  def current_user
    @current_user = User.where("id=?", session[:user_id]).first if session[:user_id]
  end

  def is_me?(user)
    if current_user
      return current_user.id == user.id
    end

    return false
  end
  
  def save_lp
    if /\/auth/i.match(request.fullpath) == nil
      session[:lp] = "#{request.fullpath}"
    end
  end
end
