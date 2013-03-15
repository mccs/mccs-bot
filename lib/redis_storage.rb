require 'redis'

class RedisStorage
  include Enumerable

  def initialize(plugin)
    @plugin = plugin.to_s
    @r = Redis.new
  end

  def compose_key(key)
    @plugin + '-' + key
  end

  def [](key)
    @r[compose_key(key)]
  end

  def []=(key, value)
    @r[compose_key(key)] = value
  end

  def each
    @r.keys(/^#{@plugin}-/)
  end

  def incr(key)
    @r.incr(compose_key(key))
  end

  def decr(key)
    @r.decr(compose_key(key))
  end
end
