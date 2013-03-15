require 'cinch'

Dir["./lib/plugins/*.rb"].each {|file| require file }

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "mccs.stu.marist.edu"
    c.channels = ["#chat"]
    c.nick = "mccs-bot"
    c.realname = "MCCS Bot"
    c.plugins.prefix = /^\?/
    c.plugins.plugins = [Hello, DiceRoll, Ligaf]
  end
end

bot.start
