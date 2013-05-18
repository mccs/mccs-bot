require 'cinch'

class Slap
  include Cinch::Plugin

  match(/slap (.+)/)
  def execute(m, target)
    m.reply "#{m.user.nick} slaps #{target} around a bit with a large trout"
  end
end
