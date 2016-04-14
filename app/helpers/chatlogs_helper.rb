module ChatlogsHelper
  def CurrentGameLog
    if Game.all.count > 1
      Game.where("is_current = ?", false).destroy_all
    end
    if Game.all.count = 0
      Game.create(:is_current => true)
    end
    Game.first.chatlogs
  end

  def DoTask(chatlog)
    # return if Wakeup.first.sleep_until > Datetime.now
    task =DoTask.first
    if task.name.equal?(TaskName::WatingForStartGame)
      if chatlog.equal?("batdau")
        CreateGame()
        DoTask.create(name: TaskName::WatingForPlayers)
        SystemLog("Mọi người vui lòng gõ bất kì để vào game");
        AddPlayer(chatlog.user)
      end
    elsif task.name.equal?(TaskName::WatingForPlayers)
      if chatlog.equal?("ketthuc")
        task.update_attribute(name: TaskName::WatingForStartGame)
        SystemLog("Game đã hủy")
      else
        if !Game.first.players.exists?(user_id: chatlog.user.id)
          AddPlayer(chatlog.user)
        end
      end
      # lack start
    end






    # Wakeup.first.sleep_until.update_attribute(:sleep_until, Time.now + DoTask.first.delay_time.seconds)
  end

  def CreateGame
    Game.destroy_all
    Game.create(:is_current => true)
  end

  def AddPlayer(user)
    total_players = Players.size
    char = TaskName::PlayerChar[total_players]
    Game.first.players.create(user_id: user.id, char: char)

    SystemLog(user.nick_name + " đã gia nhập game với tên "+char)
  end

  def SystemLog(content)
    system_user = User.where("email = 'system@cuhuuhoang.com'").first
    Game.first.chatlogs.create(user_id: system_user.id, content: content)
  end



end

module TaskName
  WatingForStartGame = "waitingforstartgame"
  WatingForPlayers = "watingforplayers"
  PlayerChar = %w{a b c d e f g h i j k l m n o p q r s t u v w x y z}
end
