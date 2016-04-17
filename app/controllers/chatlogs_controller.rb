include ChatlogsHelper

class ChatlogsController < ApplicationController
  layout "blank_layout"
  def show

    if !params[:id].nil?
      chatlog = Chatlog.find_by(id: params[:id])
    end

    if(!chatlog.nil?)
      @chatlogs = CurrentGameLog().where("(created_at > ? AND (target = 'all' OR target = '?')) AND id > ?", chatlog.created_at, current_user.id, chatlog.id)
    else
      @chatlogs = CurrentGameLog().where("created_at > ? AND (target = 'all' OR target = '?')", 10.minutes.ago, current_user.id)
    end

    CheckTask()
    #
    # respond_to do |format|
    #   format.html { redirect_to root_path }
    #   format.js
    # end
  end

  def create
    log_content=params[:chatlog][:content]
    if log_content.length > 0
      target = GetStatus(StatusName::IsNight) == "true" ? current_user.id.to_s : "all";
      chatlog =Chatlog.new(game_id: Game.first.id, content: params[:chatlog][:content], target: target, kind: 1, user_id: current_user.id)
      chatlog.save!
      DoTask(chatlog)
    end

    render :nothing => true
  end
end
