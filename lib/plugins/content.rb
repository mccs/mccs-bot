require 'cinch'

class Content
  include Cinch::Plugin

  match(/learn (.+) "(.+)"/)
  def execute(m, cmd, response)
    m.reply("Okay, learned " + cmd + " => " + response)
  end
end
