class ChatlogsController < ApplicationController
  layout "blank_layout"
  def show
    if !params[:id].nil?
      chatlog = Chatlog.find_by(id: params[:id])
      @chatlogs = Chatlog.all.where("created_at > ?", chatlog.created_at)
    else
      @chatlogs = Chatlog.all.where("created_at > ?", 10.minutes.ago)
    end
    #
    # respond_to do |format|
    #   format.html { redirect_to root_path }
    #   format.js
    # end
  end

  def create
    if params[:chatlog][:content].length > 0
      current_user.chatlogs.create!(content: params[:chatlog][:content], target: "all", kind: 1)
    end

    render :nothing => true
  end
end
