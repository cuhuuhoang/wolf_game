# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

system = User.new(email: "system@cuhuuhoang.com", nick_name: "Hệ Thống",
                  password: "12345678", password_confirmation: "12345678")
hoang =User.new (email: "cuhuuhoang@gmail.com", nick_name: "Hoàng",
                 password: "12345678", password_confirmation: "12345678")
hoang.save!
1.upto(10) do |i|
  hoang =User.new (email: "cuhuuhoang#{i}@gmail.com", nick_name: "Hoàng #{i}",
                   password: "12345678", password_confirmation: "12345678")
  hoang.save!
end


Role.new(role_id: 1, name: "Dân làng", description: "Dân làng không có bất kì chức năng đặc biệt nào cả, dân làng
theo phe dân");
Role.new(role_id: 2, name: "Ma sói", description: "Vào ban đêm, tất cả ma sói mở mắt và đi tìm những ma sói khác,
nếu không có ai mở mắt thì ma sói còn lại đang ở giữa, ma sói theo phe sói")
Role.new(role_id: 3, name: "Đạo tặc", description: "Ban đêm, đạo tặc có thể chọn cướp 1 lá bài từ người khác và đặt
nhân vật của mình thế vào lá bài kia. Sau đó đạo tặc nhìn vào lá bài mới của mình. Người mang lá bài đạo tặc
theo phe dân. Đương nhiên, anh chàng không được thực hiện chức năng của nhân vật mới vào ban đêm.
Nếu đạo tặc chọn không cướp lá bài từ những người khác, anh chàng vẫn là đạo tặc và theo phe dân")
Role.new(role_id: 4, name: "Tiên tri", description: "Ban đêm, tiên tri có thể nhìn lá bài nhân vật của người khác
hoặc là xem 2 lá bài ở giữa, nhưng không được di chuyển chúng. Tiên tri theo phe dân")
Role.new(role_id: 5, name: "Kẻ gây rối", description: "Vào ban đêm, Kẻ gây rối có thể tráo bài của 2 người khác mà
không được nhìn những lá này, Những người nhận lá bài khác thì bây giờ đã là nhân vật (và phe) mới theo
lá bài vừa đổi, dẫu cho họ không hề biết nhân vật đó là ai cho đến khi trò chơi kết thúc. Kẻ gây rối
theo phe dân")

game = Game.new(is_current: true, deck: "1,2,2,3,4,5")

game.tasks.create(name: "waitingforstartgame",begin_task: Datetime.now)

Wakeup.new()