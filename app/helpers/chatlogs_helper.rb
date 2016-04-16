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
    #special case
    if chatlog.content == "debug"
      L(task.name, chatlog.user.id)
      L(Game.first.center_card, chatlog.user.id)
    elsif chatlog.content == "confirmketthuc"
      L("Game đã bị buộc kết thúc", :all)
      CreateTask(TaskName::WatingForStartGame)
      SetStatus(StatusName::IsNight, "false")
    elsif chatlog.content == "resetnight"
      L("Màn đêm lại buông xuống 1 lần nữa", :all)
      CreateTask(TaskName::ReadWolfCompanion, 1)
    elsif chatlog.content == "resetgame"
      L("Game được bắt đầu lại", :all)
      CreateTask(TaskName::StartingGame, 1)
    elsif chatlog.content == "resetrobber"
      CreateTask(TaskName::DoneReadWolfCompanion, 1)
    elsif chatlog.content == "showme"
      L(chatlog.user.players.first.to_json, chatlog.user.id)
      L("Ban đầu bạn là "+ chatlog.user.players.first.original_role.name+ ". Bây giờ bạn là "+ chatlog.user.players.first.current_role.name, chatlog.user.id)
    end
    # L(Game.all.to_json)
    if task.name == TaskName::WatingForStartGame
      if chatlog.content == "batdau"
        # L(Task.first.name)
        # L(Game.all.size.to_s)
        CreateGame()
        CreateTask(TaskName::WatingForPlayers)
        L("Mọi người vui lòng gõ bất kì để vào game", :all)
        AddPlayer(chatlog.user)
      end
    elsif task.name == TaskName::WatingForPlayers
      if chatlog.content == "ketthuc"
        CreateTask(TaskName::WatingForStartGame)
        SetStatus(StatusName::IsNight, "false")
        L("Game đã hủy", :all)
      elsif chatlog.content == "confirm"
        CreateTask(TaskName::StartingGame, 1)
        #showwolfcompanion 5s
        #tellelfchooseonecardortwomiddlecards
        #tellrobberchangecards
        #tellpharoiswapcards
        #thedaycome, nowallchatvisible
        #nowvote
        #showvoteresult, whowin
      else #go bat ki de gia nhap game
        if !Game.first.players.exists?(user_id: chatlog.user.id)
          AddPlayer(chatlog.user)
        end
      end
    elsif task.name == TaskName::WolfReadCenterCard
      if chatlog.user.players.first.original_role.role_id == 2
        if ['1','2','3'].include?(chatlog.content)
          card_role_id = Game.first.center_card.split(",")[chatlog.content.to_i - 1]
          L("Quân bài bạn chọn là "+ Role.where("role_id = ?", card_role_id).first.name , chatlog.user.id)
          CreateTask(TaskName::DoneReadWolfCompanion, 1)
        else
          L("Xin nhập lại quân bài bạn muốn chọn trong số 1 hoặc 2 hoặc 3", chatlog.user.id)
          CreateTask(TaskName::WolfReadCenterCard)
        end
      end
    elsif task.name == TaskName::SeerReadingCard
      if chatlog.user.players.first.original_role.role_id ==4
        players_char = Player.pluck(:char)
        if players_char.include?(chatlog.content) && chatlog.content != chatlog.user.players.first.char
          player_to_view = Player.where("char = ?", chatlog.content).first
          L("Quân bài của "+ player_to_view.user.nick_name + " - "+player_to_view.char+
                " là: "+player_to_view.current_role.name, chatlog.user.id)
          CreateTask(TaskName::DoneSeerJob,1)
        elsif ['12','23','13', '21', '32', '31'].include?(chatlog.content)
          seen_card = "Quân bài bạn đọc được là :"
          if chatlog.content.include?('1')
            card_role_id = Game.first.center_card.split(",")[0]
            seen_card+= "1 - " + Role.where("role_id = ?", card_role_id).first.name + " , "
          end
          if chatlog.content.include?('2')
            card_role_id = Game.first.center_card.split(",")[1]
            seen_card+= "2 - " + Role.where("role_id = ?", card_role_id).first.name + " , "
          end
          if chatlog.content.include?('3')
            card_role_id = Game.first.center_card.split(",")[2]
            seen_card+= "3 - " + Role.where("role_id = ?", card_role_id).first.name + " , "
          end
          L(seen_card, chatlog.user.id)
          CreateTask(TaskName::DoneSeerJob,1)
        else
          L("Xin nhập lại quân bài bạn muốn chọn . bạn được phép đọc bài bất kì ai, nhập a,b,c,d,.. để đọc,
              hoặc đọc 2 lá bài ở giữa 1,2,3 ví dụ nhập '12' hoặc 'c' hoặc '13'"+ PlayerInGame(), chatlog.user.id)
          CreateTask(TaskName::SeerReadingCard)
        end
      end
    elsif task.name == TaskName::RobberTakingOtherCard
      if chatlog.user.players.first.original_role.role_id == 3
        players_char = Player.pluck(:char)
        if players_char.include?(chatlog.content) && chatlog.content != chatlog.user.players.first.char
          player_changed = Player.where("char = ?", chatlog.content).first
          L("Bạn đã tráo bài với "+ player_changed.user.nick_name + " - "+player_changed.char+
                ". Quân bài mới bạn nhận được là "+player_changed.current_role.name, chatlog.user.id)
          robber_role_id = chatlog.user.players.first.current_role.id
          new_role_id = player_changed.current_role.id
          # L(robber_role_id+ " " +new_role_id, chatlog.user.id)
          player_changed.update_attribute(:current_role_id, robber_role_id)
          chatlog.user.players.first.update_attribute(:current_role_id, new_role_id)
          CreateTask(TaskName::DoneRobberJob,1)
        elsif chatlog.content == '0'
          L("Bạn đã bỏ qua không tráo bài với ai", chatlog.user.id)
          CreateTask(TaskName::DoneRobberJob,1)
        else
          L("Xin nhập lại quân bài bạn muốn chọn . Bạn được phép tráo bài với bất kì ai, nhập a,b,c,d,.. để tráo,
                 hoặc nhập 0 để bỏ qua. "+PlayerInGame(), chatlog.user.id)
          CreateTask(TaskName::RobberTakingOtherCard)
        end
      end
    elsif task.name == TaskName::TroubleSwapCard
      if chatlog.user.players.first.original_role.role_id == 5
        players_char = Player.pluck(:char)
        if chatlog.content.length == 2 && players_char.include?(chatlog.content[1]) && players_char.include?(chatlog.content[0]) && !chatlog.content.include?(chatlog.user.players.first.char)
          player1 = Player.where("char = ?", chatlog.content[0]).first
          player2 = Player.where("char = ?", chatlog.content[1]).first

          L("Bạn đã tráo bài giữa "+ PlayerInGameName(player1.user) +
                " và "+ PlayerInGameName(player2.user), chatlog.user.id)
          player1_role_id = player1.current_role.id
          player2_role_id = player2.current_role.id

          player1.update_attribute(:current_role_id, player2_role_id)
          player2.update_attribute(:current_role_id, player1_role_id)

          CreateTask(TaskName::DoneTroubleCard,1)
        else
          L("Xin nhập lại quân bài bạn muốn chọn . bạn được phép tráo bài của 2 người bất kì, nhập 'ab', 'de', 'cd',.. để tráo giữa 2 người. "+PlayerInGame(), chatlog.user.id)
          CreateTask(TaskName::TroubleSwapCard)
        end
      end
    elsif task.name == TaskName::DiscussingToFindWolf
      if chatlog.content == "beginvote"
        SetStatus(StatusName::IsNight, "true")
        L("Mọi người hãy vote người mà bạn nghĩ là sói bằng cách nhập 1 chữ cái a,b,c,d ..." +PlayerInGame(), :all )
        CreateTask(TaskName::CheckingVote)
      end
    elsif task.name == TaskName::CheckingVote
      players_char = Player.pluck(:char)
      if players_char.include?(chatlog.content) && chatlog.content != chatlog.user.players.first.char
        chatlog.user.players.first.update_attribute(:vote, chatlog.content)
        target = Player.where("char = ?", chatlog.content).first
        L("Bạn đã vote cho "+ target.user.nick_name + " - "+target.char, chatlog.user.id)
        log_all = "Đã ghi nhận vote của "+ PlayerInGameName(chatlog.user)+ ". Còn "
        count =0
        Game.first.players.each do |player|
          if player.vote.nil?
            log_all+= PlayerInGameName(player.user)+ " , "
            count +=1
          end
        end
        log_all += "chưa vote"
        if (count > 0)
          L(log_all, :all)
        else
          L("Đã vote xong", :all)
          SetStatus(StatusName::IsNight, "false")
          CreateTask(TaskName::DoneVote,1)
        end

      else
        L("Xin nhập lại người mà bạn nghĩ là sói bằng cách nhập 1 chữ cái a,b,c,d ..." +PlayerInGame(), chatlog.user.id)
      end
    end
    # L(Task.first.name)
    # L(Task.all.size.to_s)
    # Wakeup.first.sleep_until.update_attribute(:sleep_until, Time.now + DoTask.first.delay_time.seconds)
  end

  def CheckTask
    giveuptime = DateTime.strptime(GetStatus(StatusName::GiveUpTime), '%Y-%m-%dT%H:%M:%S%z')
    if giveuptime < DateTime.now
      SetStatus(StatusName::GiveUpTime, DateTime.now + 100.years)
      task =Task.first
      if task.name == TaskName::StartingGame
        StartGame()
        SetStatus(StatusName::IsNight, "true")
        L("Mọi câu nói của các bạn từ bây giờ sẽ không ai thấy", :all)
        CreateTask(TaskName::WatingForReadingRole, 5)
      elsif task.name == TaskName::WatingForReadingRole
        L("Game chính thức bắt đầu, màn đêm bắt đầu buông xuống", :all)
        CreateTask(TaskName::ReadWolfCompanion, 3)
      elsif task.name == TaskName::ReadWolfCompanion
        L("Sói đang đi tìm kiếm bạn đồng hành của mình", :all)
        wolfs_in_game = Role.where("role_id = '2'").first.original_role_players
        # L(wolfs_in_game.to_s, :all)
        # L(wolfs_in_game.size, :all)
        if wolfs_in_game.size == 1
          L("Bạn là ma sói duy nhất trong game, bạn được xem 1 quân bài ở giữa, vui lòng nhập một trong các số 1,2,3", wolfs_in_game.first.user.id)
          CreateTask(TaskName::WolfReadCenterCard)
        elsif wolfs_in_game.size ==2
          L("Ma sói khác trong số người cùng chơi là "+ wolfs_in_game[1].user.nick_name + " - " +wolfs_in_game[1].char, wolfs_in_game[0].user.id)
          L("Ma sói khác trong số người cùng chơi là "+ wolfs_in_game[0].user.nick_name + " - " +wolfs_in_game[0].char, wolfs_in_game[1].user.id)
          CreateTask(TaskName::DoneReadWolfCompanion, 5)
        else
          CreateTask(TaskName::DoneReadWolfCompanion, 5)
        end
      elsif task.name == TaskName::DoneReadWolfCompanion
        L("Sói đã hoàn thành nhiệm vụ và nhắm mắt ngủ tiếp", :all)
        L("Tiên tri đang thức giấc và thực hiện công việc của mình", :all)
        seer_in_game = Role.where("role_id = '4'").first.original_role_players
        if seer_in_game.size == 1
          L("Bạn chính là tiên tri, bạn được phép đọc bài bất kì ai, nhập a,b,c,d,.. để đọc, hoặc đọc 2 lá bài ở giữa 1,2,3
                      ví dụ nhập '12' hoặc 'c' hoặc '13'"+ PlayerInGame(), seer_in_game.first.user.id)
          CreateTask(TaskName::SeerReadingCard)
        else
          CreateTask(TaskName::DoneSeerJob,5)
        end
      elsif task.name == TaskName::DoneSeerJob
        L("Tiên tri đã hoàn thành nhiệm vụ và nhắm mắt ngủ tiếp", :all)
        L("Đạo tặc đang thức dậy và thực hiện công việc của mình", :all)
        robber_in_game = Role.where("role_id = '3'").first.original_role_players
        if robber_in_game.size == 1
          L("Bạn chính là đạo tặc, bạn được phép tráo bài với bất kì ai, nhập a,b,c,d,.. để tráo, hoặc nhập 0 để bỏ qua. "+PlayerInGame(),robber_in_game.first.user.id)
          CreateTask(TaskName::RobberTakingOtherCard)
        else
          CreateTask(TaskName::DoneRobberJob,5)
        end
      elsif task.name ==TaskName::DoneRobberJob
        L("Đạo tặc đã hoàn thành nhiệm vụ và nhắm mắt ngủ tiếp", :all)
        L("Kẻ gây rối đang thức dậy và thực hiện công việc của mình", :all)
        trouble_in_game = Role.where("role_id = '5'").first.original_role_players
        if trouble_in_game.size == 1
          L("Bạn chính là kẻ gây rối, bạn được phép tráo bài của 2 người bất kì, nhập 'ab', 'de', 'cd',.. để tráo giữa 2 người. "+PlayerInGame(),trouble_in_game.first.user.id)
          CreateTask(TaskName::TroubleSwapCard)
        else
          CreateTask(TaskName::DoneTroubleCard,5)
        end
      elsif task.name == TaskName::DoneTroubleCard
        L("Kẻ gây rối đã hoàn thành nhiệm vụ và nhắm mắt ngủ tiếp", :all)
        L("Trời đã sáng, mọi người đã có thể nói chuyện với nhau để tìm ra ai là sói.", :all)
        SetStatus(StatusName::IsNight, "false")
        CreateTask(TaskName::DiscussingToFindWolf)
      elsif task.name == TaskName::DoneVote
        vote_all = Player.pluck(:vote)
        log_all = "Vote: "
        log_all_1 = "Thân phận: "
        Game.first.players.each do |player|
          if player.vote.nil?
            log_all+= PlayerInGameName(player.user)+ " , "
            count +=1
          end
          log_all+= PlayerInGameName(player.user)+ " vote cho " + PlayerInGameName(Player.where("char = ?",player.vote).first.user) + " , "
          add_str=""
          if player.current_role.name != player.original_role.name
            add_str += "(ban đầu là "+player.original_role.name+ " )"
          end
          total_vote_receive = 0
          vote_all.each {|vote| total_vote_receive+= 1 if vote == player.char}
          log_all_1 += PlayerInGameName(player.user)+ " là " + player.current_role.name + add_str+ " nhận được" + total_vote_receive.to_s +  " , "
        end
        L(log_all, :all)
        L(log_all_1, :all)
        CreateTask(TaskName::WatingForStartGame)
      end
    end
  end


  def StartGame

    players = Game.first.players.all
    total_players = players.size

    role_array = [1,2,2,3,4,5]
    if total_players > (role_array.size - 3)
      (total_players - role_array.size + 3).times{ |i| role_array.push(1)}
    end
    role_array = role_array.shuffle
    center_card = role_array[-3, 3].join(",")
    Game.first.update_attribute(:center_card, center_card)

    count =0
    L(PlayerInGame(), :all)

    players.each do |player|
      role = Role.where("role_id = ?", role_array[count].to_s).first
      player.update_attributes(:original_role_id => role.id, :current_role_id => role.id)

      log_private = "Bạn là : " + role.name + ". " + role.description
      L(log_private, player.user.id)
      count+=1
    end

  end

  def CreateGame
    Game.destroy_all
    Game.create(:is_current => true)
    Game.first.game_statuses.create(name: "isnight", value: "false")
    Game.first.game_statuses.create(name: "giveuptime", value: DateTime.now+ 100.years)
  end

  def CreateTask(name, delay = 0)
    Task.destroy_all
    Task.create(name: name)
    if(delay > 0)
      SetStatus(StatusName::GiveUpTime, DateTime.now + delay.seconds)
    end
  end

  def AddPlayer(user)
    total_players = Player.all.size
    char = TaskName::PlayerChar[total_players]
    Game.first.players.create(user_id: user.id, char: char)

    L(user.nick_name + " đã gia nhập game với tên '"+char+"'", :all)
  end

  def L(content, target)
    system_user = User.where("email = ?", "system@cuhuuhoang.com").first
    Game.first.chatlogs.create(user_id: system_user.id, content: content, target: target)
  end

  def SetStatus(name, value)
    game_status = Game.first.game_statuses.where(name: name).first
    game_status.update_attribute(:value, value)
  end

  def GetStatus(name)
    Game.first.game_statuses.where(name: name).first.value
  end

  def PlayerInGame
    log_all = "Thông tin người chơi: "
    Game.first.players.each do |player|
      log_all+= player.user.nick_name + " - " + player.char + " , "
    end
    return log_all
  end

  #erb function
  def SpeechClass(chatlog)
    if chatlog.user.id == current_user.id
      'speech-right'
    elsif chatlog.target == current_user.id.to_s
      'speech-single'
    elsif chatlog.user.email == "system@cuhuuhoang.com"
      'speech-system'
    else
      ''
    end
  end

  def PlayerInGameName(user)
    user.nick_name + " - " +user.players.first.char
  end


end

module TaskName
  WatingForStartGame = "waitingforstartgame"
  WatingForPlayers = "watingforplayers"
  StartingGame = "startinggame"
  WatingForReadingRole = "waitingforreadingrole"
  ReadWolfCompanion = "readwolfcompanion"
  WolfReadCenterCard = "wolfreadcentercard"
  DoneReadWolfCompanion ="donereadwolfcompanion"
  SeerReadingCard ="seerreadingcard"
  DoneSeerJob = "doneseerjob"
  RobberTakingOtherCard = "robbertakingothercard"
  DoneRobberJob ="donerobberjob"
  TroubleSwapCard = "troubleswapcard"
  DoneTroubleCard ="donetroublecard"
  DiscussingToFindWolf = "discussingtofindwolf"
  CheckingVote = "checkingvote"
  DoneVote = "donevote"

  PlayerChar = %w{a b c d e f g h i j k l m n o p q r s t u v w x y z}
end

module StatusName
  IsNight = "isnight"
  GiveUpTime = "giveuptime"

end