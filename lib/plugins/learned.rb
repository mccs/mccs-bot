require 'cinch'
require 'json'
require './lib/redis_storage'

class Learn
  include Cinch::Plugin

  @@store = RedisStorage.new(Learn)

  match(/learn (.+) "(.+)"/, method: :learn)
  def learn(m, cmd, response)
    old = @@store[cmd]
    if old
      old = JSON.parse(old)
      old.push(response)
    else
      old = [response]
    end
    @@store[cmd] = old.to_json
    puts @@store[cmd]
    m.reply("learned " + cmd + " => " + response)
  end

  match(/((?!learn).+)/, method: :execute)
  def execute(m, cmd)
    vals = @@store[cmd]
    if vals
      m.reply(JSON.parse(vals).sample)
    end
  end

end
