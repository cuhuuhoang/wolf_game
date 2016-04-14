module ChatlogsHelper
  def CurrentGameLog
    if Game.all.count > 1
      Game.destroy_all
    end
    if Game.all.count == 0
      Game.create(:is_current => true)
    end
    Game.first.chatlogs
  end

  def DoTask(chatlog)
    # return if Wakeup.first.sleep_until > Datetime.now
    task =Task.first

    # SystemLog(Game.all.to_json)
    if task.name == TaskName::WatingForStartGame
      if chatlog.content == "batdau"
        CreateGame()
        CreateTask(TaskName::WatingForPlayers)
        SystemLog("Mọi người vui lòng gõ bất kì để vào game");
        AddPlayer(chatlog.user)
      end
    elsif task.name == TaskName::WatingForPlayers
      if chatlog.content == "ketthuc"
        CreateTask(TaskName::WatingForStartGame)
        SystemLog("Game đã hủy")
      else #go bat ki de gia nhap game
        if !Game.first.players.exists?(user_id: chatlog.user.id)
          AddPlayer(chatlog.user)
        end
      end
      # lack start
    end
    # SystemLog(Task.first.name)
    # SystemLog(Task.all.size.to_s)
    # Wakeup.first.sleep_until.update_attribute(:sleep_until, Time.now + DoTask.first.delay_time.seconds)
  end

  def CreateGame
    Game.destroy_all
    Game.create(:is_current => true)
  end

  def CreateTask(name)
    Task.destroy_all
    Game.first.tasks.create(name: name)
  end

  def AddPlayer(user)
    total_players = Player.all.size
    char = TaskName::PlayerChar[total_players]
    Game.first.players.create(user_id: user.id, char: char)

    SystemLog(user.nick_name + " đã gia nhập game với tên '"+char+"'")
  end

  def SystemLog(content)
    system_user = User.where("email = ?", "system@cuhuuhoang.com").first
    Game.first.chatlogs.create(user_id: system_user.id, content: content)
  end



end

module TaskName
  WatingForStartGame = "waitingforstartgame"
  WatingForPlayers = "watingforplayers"
  PlayerChar = %w{a b c d e f g h i j k l m n o p q r s t u v w x y z}
end
