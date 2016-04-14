class StaticPagesController < ApplicationController
  def home
    @chatlog = current_user.chatlogs.build
  end

  def help
  end
end
