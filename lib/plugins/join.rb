require 'cinch'

class Join
  include Cinch::Plugin

  match(/join (.+)/)
  def execute(m, channel)
    Channel(channel).join
  end
end
