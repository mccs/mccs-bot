require 'cinch'

class Nope
  include Cinch::Plugin

  match('nope')
  def execute(m)
    nopes = ["http://img6.imagebanana.com/img/cj8juagu/tumblr_lope3fakj51qip78p.gif"]
    m.reply nopes.sample
  end
end
