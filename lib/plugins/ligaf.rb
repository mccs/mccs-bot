require 'cinch'

class Ligaf
  include Cinch::Plugin

  match('ligaf')
  def execute(m)
    m.reply "Command not understood"
  end
end
