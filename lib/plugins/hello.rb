require 'cinch'

class Hello
  include Cinch::Plugin

  match "hello"

  def execute(m)
    m.reply "Hello, #{m.user.nick}. Welcome to the MCCS IRC Channel!"
  end
end

