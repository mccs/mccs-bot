require 'cinch'

class Deploy
  include Cinch::Plugin

  match "deploy"

  def execute(m)
    m.reply "Goodbye cruel world"
    Thread.new {
      Kernel.exec('ruby ./bot.rb')
    }
    @bot.nick = 'mccs-bot_dead'
    @bot.quit
  end
end
