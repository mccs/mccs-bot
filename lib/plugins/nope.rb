require 'cinch'

class Nope
  include Cinch::Plugin

  match('nope')
  def execute(m)
    nopes = [
      "http://bukk.it/tracynope.gif",
      "http://bukk.it/nuhnope.gif",
      "http://i.imgur.com/R2v3c6H.gif",
      "http://i.imgur.com/RMsnqCF.gif",
      "http://i.imgur.com/0U2cnck.gif"
    ]
    m.reply nopes.sample
  end
end
