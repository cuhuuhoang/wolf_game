include ChatlogsHelper

class ChatlogsController < ApplicationController
  layout "blank_layout"
  def show
    if !params[:id].nil?
      chatlog = Chatlog.find_by(id: params[:id])
    end

    if(!chatlog.nil?)
      @chatlogs = CurrentGameLog().where("created_at > ? ", chatlog.created_at)
    else
      @chatlogs = CurrentGameLog().where("created_at > ?", 10.minutes.ago)
    end
    #
    # respond_to do |format|
    #   format.html { redirect_to root_path }
    #   format.js
    # end
  end

  def create
    log_content=params[:chatlog][:content]
    if log_content.length > 0
      chatlog =Chatlog.new(game_id: Game.first.id, content: params[:chatlog][:content], target: "all", kind: 1, user_id: current_user.id)
      chatlog.save!
      DoTask(chatlog)
    end

    render :nothing => true
  end
end
