require 'cinch'

class Nope
  include Cinch::Plugin

  match('nope')
  def execute(m)
    nopes = ["http://i.imgur.com/ni4kyJu.gif"]
    m.reply nopes.sample
  end
end
