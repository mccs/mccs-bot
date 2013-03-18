require 'cinch'
require './lib/redis_storage'

class Learn
  include Cinch::Plugin

  match(/learn (.+) "(.+)"/, method: :learn)
  def learn(m, cmd, response)
    m.reply("Okay, learned " + cmd + " => " + response)
  end

  match(/^.+/)
  def execute(m, cmd)
    m.reply("catch all exec '#{cmd}'")
  end

end
