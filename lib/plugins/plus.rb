require 'cinch'
require 'leaderboard'
require './lib/redis_storage'

class Plus
  include Cinch::Plugin


  match(/\+\+ (.+)/, method: :plus)
  def plus(m, target)
    @plus_lb = Leaderboard.new('pluses')
    if (target == m.user.nick)
      @plus_lb.change_score_for(target, -1)
      total = @plus_lb.score_for(target).to_i
      m.reply("No cheating #{m.user.nick}! -1 Plus! #{m.user.nick} now has " + total.to_s + " pluses!")
    else
      @plus_lb.change_score_for(target, 1)
      total = @plus_lb.score_for(target).to_i
      m.reply(target.to_s + " got a plus! " + target.to_s + " now has " + total.to_s + " pluses!")
    end
  end

  match(/pluses (.+)/, method: :get_plus)
  def get_plus(m, target)
    @plus_lb = Leaderboard.new('pluses')
    total = @plus_lb.score_for(target).to_i
    m.reply("#{m.user.nick} has " + total.to_s + " pluses")
  end

  match(/plus_leaders/, method: :get_leaders)
  def get_leaders(m)
    @plus_lb = Leaderboard.new('pluses')
    leaders = @plus_lb.members_from_rank_range(1, 10)
    leader_string = ''
    leaders.each do |leader|
      leader_string = leader_string + leader[:rank].to_s + ". " + leader[:member] + ": " + leader[:score].to_i.to_s + ", "
    end
    m.reply(leader_string)
  end
end
