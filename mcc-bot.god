God.watch do |w|
  w.name = "mccs-bot"
  w.start = "ruby ./bot.rb"
  w.keepalive
end
