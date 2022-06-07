# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

puts "Reset database..."

# destroy methods here
Message.destroy_all
Chatroom.destroy_all
User.destroy_all
Game.destroy_all

puts "Done"
puts "-------------------------"
puts "Creating Users..."

def create_user(username, photo_name)
  user = User.create!(
    username: username,
    email: "#{username.downcase}@#{username.downcase}.fr",
    password: "secret"
  )
  user.photo.attach(io: URI.open(photo_name), filename: "#{username}.png", content_type: 'image/png')
  user
end

user1 = create_user("Jojo", "https://res.cloudinary.com/guilhem/image/upload/v1654164976/dbn8hfvqjsznung2bh13.png")
user2 = create_user("Raf", "https://res.cloudinary.com/guilhem/image/upload/v1654165057/fllqqsshwwbtdui9hfy3.jpg")
user3 = create_user("Guil", "https://res.cloudinary.com/guilhem/image/upload/v1654163999/gxsbqkou4cd35p8avros.jpg")
user4 = create_user("Raja", "https://res.cloudinary.com/guilhem/image/upload/v1654165101/sz1uvyn8pmbcsumxw7g1.jpg")
user5 = create_user("Phhhh", "https://res.cloudinary.com/guilhem/image/upload/v1654165008/bmzvlpj1kbesrdwd0xiy.jpg")
user6 = create_user("tatayoyo", "https://res.cloudinary.com/guilhem/image/upload/v1654164976/dbn8hfvqjsznung2bh13.png")
user7 = create_user("ProGamer853", "https://res.cloudinary.com/guilhem/image/upload/v1654165033/lmtabkus4lhv8pzj1c4z.png")
user8 = create_user("DuckyDuck", "https://res.cloudinary.com/guilhem/image/upload/v1654164048/xyb1mo8zyenjsth20rgv.jpg")
user9 = create_user("Jane", "https://res.cloudinary.com/guilhem/image/upload/v1654164976/dbn8hfvqjsznung2bh13.png")
user10 = create_user("britta", "https://res.cloudinary.com/guilhem/image/upload/v1654164976/dbn8hfvqjsznung2bh13.png")
user11 = create_user("QueenB", "https://res.cloudinary.com/guilhem/image/upload/v1654164976/dbn8hfvqjsznung2bh13.png")

puts "Done"
puts "-------------------------"
puts "Creating Ongoing Games..."

def create_ongoing_game(creator, opponent)
  # Chatroom.create!(name: "Test", game_id: @game.id)
  @game = Game.new(ongoing: true)
  @game.save!
  @grid_owner = Grid.new(game: @game, user: creator, creator: true, playing: false)
  @grid_opponent = Grid.new(game: @game, user: opponent, playing: true)
  grid_creation(@grid_owner)
  grid_creation(@grid_opponent)
end

def grid_creation(grid)
  desk_positions = (1..@game.grid_size**2).to_a.sample(@game.cells_number)
  int = 1
  (@game.grid_size**2).times do
    cell = Cell.new(grid: grid)
    cell.position = int
    cell.full = true if desk_positions.include?(cell.position)
    cell.save
    int += 1
  end
end

ongoing_game1 = create_ongoing_game(user1, user11)
ongoing_game2 = create_ongoing_game(user6, user7)
ongoing_game3 = create_ongoing_game(user4, user2)
ongoing_game4 = create_ongoing_game(user9, user3)

puts "Done"
puts "-------------------------"
puts "Creating Ended Games..."

def create_ended_game(creator, opponent)
  @game = Game.new
  @game.save!
  @grid_owner = Grid.create(game: @game, user: creator, creator: true, playing: false)
  @grid_opponent = Grid.create(game: @game, user: opponent, playing: false, win: true)
  grid_creation(@grid_owner)
  grid_creation(@grid_opponent)
end

ended_game1 = create_ended_game(user5, user3)
ended_game1 = create_ended_game(user8, user10)

puts "All Good Guys"
puts "-------------------------"
puts "Ready to play!"
