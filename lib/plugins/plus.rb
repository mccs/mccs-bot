require 'cinch'
require 'json'
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

  def reasons_string(reasons)
    if reasons.length > 1
      "They have been given for: #{reasons[0..-2].join(', ')} and #{reasons[-1]}"
    else
      "They have been given for: #{reasons[0]}"
    end
  end
  
  def get_reasons(target)
    @plus_lb = Leaderboard.new(@@PLUS_LEADERBOARD)
    member_data = @plus_lb.member_data_for(target)
    if member_data
      JSON.parse(member_data)["reasons"]
    end
  end

  def add_reason(target, reason)
    @plus_lb = Leaderboard.new(@@PLUS_LEADERBOARD)
    reasons = get_reasons(target)
    if reasons
      @plus_lb.update_member_data(target, JSON.generate({"reasons"=>reasons << reason})) unless reasons.include?(reason)
    else
      @plus_lb.update_member_data(target, JSON.generate({"reasons"=>[reason]}))
    end
  end

  match(/\+\+ (.+)/, method: :plus)
  def plus(m, target)
    @plus_lb = Leaderboard.new('pluses')
    user, reason = target.split(/\s+(?:for|because)\s+/, 2)
    if (user == m.user.nick)
      take_plus user
      m.reply "No cheating #{m.user.nick}! -1 Plus! #{get_total(user)}"
    else
      give_plus user
      add_reason(user, reason) unless reason.nil?
      m.reply "#{user} got a plus#{" for " + reason if reason}! #{get_total(user)}"
    end
  end

  match(/pluses (.+)/, method: :get_plus)
  def get_plus(m, target)
    @plus_lb = Leaderboard.new('pluses')
    reasons = get_reasons(target)
    if reasons.nil? || reasons.empty?
      m.reply "#{get_total(target)}"
    else
      m.reply "#{get_total(target)} #{reasons_string(reasons)}"
    end
  end

  match(/leaders/, method: :get_leaders)
  def get_leaders(m)
    @plus_lb = Leaderboard.new(@@PLUS_LEADERBOARD)
    m.reply @plus_lb.members_from_rank_range(1, 10).inject('') {|l|
      "#{l[:score].to_i.to_s} - #{l[:member]}, "
    }
  end

end
