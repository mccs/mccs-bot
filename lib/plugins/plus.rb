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

  def get_reasons(target)
    @plus_lb = Leaderboard.new(@@PLUS_LEADERBOARD)
    member_data = @plus_lb.member_data_for(target)
    if member_data
      JSON.parse(member_data)["reasons"]
    end
  end

  def add_reason(target, reason)
    @plus_lb = Leaderboard.new(@@PLUS_LEADERBOARD)
    #reasons = JSON.parse(@plus_lb.member_data_for(target))["reasons"]
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
    #reasons = JSON.parse(@plus_lb.member_data_for(target))["reasons"]
    reasons = get_reasons(target)
    if reasons.nil? || reasons.empty?
      m.reply "#{get_total(target)}"
    else
      m.reply "#{get_total(target)} They were given for #{reasons.join(', ')}"
    end
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
