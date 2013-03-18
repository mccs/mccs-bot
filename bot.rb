require 'cinch'
require 'yaml'

Dir["./lib/plugins/*.rb"].each {|file| require file }

config = YAML.load_file('config.yml')

bot = Cinch::Bot.new do
  configure do |c|
    c.server = config['server']
    c.channels = config['channels']
    c.nick = config['nick']
    c.realname = config['realname']
    c.plugins.prefix = Regexp.new config['prefix']
    c.plugins.plugins = config['plugins'].map! {|p| Object.const_get p }
  end
end

bot.start
