require 'cinch'
require 'yaml'

Dir["./lib/plugins/*.rb"].each {|file|
  puts 'loaded ' + file
  require file
}

begin
  puts 'checking for dev.config.yml...'
  config = YAML.load_file('dev.config.yml')
  puts 'loaded dev.config.yml!'
rescue
  config = YAML.load_file('config.yml')
  puts 'no dev.config.yml... loaded config.yml!'
end

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
