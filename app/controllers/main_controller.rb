class MainController < ApplicationController

  def index
    @sls = ShortLink.get_by_user_id (current_user.id ) if current_user
    @sls = ShortLink.get_by_session_id session_id if !@sls
  end

  def shorten
    @sl = ShortLink.new

    @sl.set_url params[:u]

    if current_user
      @sl.user_id = current_user.id
    else
      @sl.session_id = request.session_options[:id]
    end

    if @sl.save
      @sls = ShortLink.get_by_user_id (current_user.id ) if current_user
      @sls = ShortLink.get_by_session_id session_id if !@sls
      respond_to do |format|
        format.html { render "index" }
        format.xml  { render xml: @sl}
        format.json { render json: @sl}
      end
    end
  end

  def jump
    @sl = ShortLink.get_by_short( params[:link_id] )

    return show_404 if !@sl

    @sl.increment(:clicks)

    return redirect_to @sl.link if @sl.save

    return render text: 'Something went wrong.'

  end

  def debug
    return render text: "<pre>Hi"
  end

  private

  def url_params
    params.require(:url).permit(:title, :description, :page_content, :image, :expires, :status)
  end

  def session_id
    return request.session_options[:id]
  end

end
