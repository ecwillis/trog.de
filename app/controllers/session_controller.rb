class SessionController < ApplicationController

  def callback

    ## return render text: "<pre>#{auth_hash.to_yaml}"
    if current_user
      _result = current_user.add_new_auth(auth_hash())
      if _result.nil?
        flash[:error] = "This account is already in use."
      end
    else
      @user = User.find_by_auth(auth_hash()) || User.create_with_auth(auth_hash())
      session[:user_id] = @user.id
      # if(@user.is_fresh?)
      #   return redirect_to '/account_setup'
      # end
    end
    
    handle_redirect
  end

  def destroy
    reset_session
    redirect_to :root
  end

  private
  
  def auth_hash
    request.env['omniauth.auth']
  end

end