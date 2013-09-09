require 'cinch'

class Nope
  include Cinch::Plugin

  match('nope')
  def execute(m)
    nopes = [
      "http://img6.imagebanana.com/img/cj8juagu/tumblr_lope3fakj51qip78p.gif",
      "http://bukk.it/tracynope.gif",
      "http://bukk.it/nuhnope.gif",
      "http://i.imgur.com/R2v3c6H.gif",
      "http://i.imgur.com/RMsnqCF.gif",
      "http://i.imgur.com/0U2cnck.gif"
    ]
    m.reply nopes.sample
  end
end
