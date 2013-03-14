require 'cinch'

class Ligaf
  include Cinch::Plugin

  match "ligaf"
  def execute(m)
    m.reply "ligaf"
  end
end
