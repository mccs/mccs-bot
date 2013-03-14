require 'cinch'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "mccs.stu.marist.edu"
    c.channels = ["#chat"]
  end

  on :message, "hello" do |m|
    m.reply "Hello, #{m.user.nick}"
  end
end

bot.start
