require 'cinch'

class Ligaf
  include Cinch::Plugin

  match('ligaf')
  def execute(m)
    ligafs = ["http://images3.wikia.nocookie.net/__cb20120221212715/smuff/images/6/6c/LIGAF.gif", "http://www.troll.me/images/rainbow-spongebob/like-i-give-a-fuck.jpg"]
    m.reply ligafs.sample
  end
end
