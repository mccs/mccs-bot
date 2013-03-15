require 'cinch'

class Ligaf
  include Cinch::Plugin

  match "ligaf"
  def execute(m)
    m.reply "http://www.troll.me/images/rainbow-spongebob/like-i-give-a-fuck.jpg"
  end
end
