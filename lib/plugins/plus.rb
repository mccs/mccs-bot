require 'cinch'
require 'leaderboard'
require './lib/redis_storage'

class Plus
  include Cinch::Plugin
  @@PLUS_LEADERBOARD = 'pluses'

  def give_plus(target)
    @plus_lb = Leaderboard.new(@@PLUS_LEADERBOARD)
    @plus_lb.change_score_for(target, 1)
  end

  def take_plus(target)
    @plus_lb = Leaderboard.new(@@PLUS_LEADERBOARD)
    @plus_lb.change_score_for(target, -1)
  end

  def get_total(target)
    total = @plus_lb.score_for(target).to_i
    if total == 1 || total == -1
      return "#{target} now has " + total.to_s + " plus!"
    else
      return "#{target} now has " + total.to_s + " pluses!"
    end
  end

  match(/\+\+ (.+)/, method: :plus)
  def plus(m, target)
    @plus_lb = Leaderboard.new('pluses')
    if (target == m.user.nick)
      take_plus target
      m.reply "No cheating #{m.user.nick}! -1 Plus! #{get_total(target)}"
    else
      give_plus target
      m.reply "#{target} got a plus! #{get_total(target)}"
    end
  end

  match(/pluses (.+)/, method: :get_plus)
  def get_plus(m, target)
    m.reply "#{get_total(target)}"
  end

  match(/plus_leaders/, method: :get_leaders)
  def get_leaders(m)
    @plus_lb = Leaderboard.new(@@PLUS_LEADERBOARD)
    leaders = @plus_lb.members_from_rank_range(1, 10)
    leader_string = ''
    leaders.each do |leader|
      leader_string = leader_string + leader[:rank].to_s + ". " + leader[:member] + ": " + leader[:score].to_i.to_s + ", "
    end
    m.reply(leader_string)
  end

end
