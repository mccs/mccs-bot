require 'cinch'
require './lib/redis_storage'

class Plus
  include Cinch::Plugin

  match(/\+\+ (.+)/)
  def execute(m, target)
    r = RedisStorage.new(self)
    if (target == m.user.nick)
      r.decr(target)
      total = r[target]
      m.reply("No cheating #{m.user.nick}! -1 Plus!")
    else
      r.incr(target)
      total = r[target]
      m.reply(target.to_s + " got a plus! " + target.to_s + " now has " + total.to_s + " plusses!")
    end
  end
end
