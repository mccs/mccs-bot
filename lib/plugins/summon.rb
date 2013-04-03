require 'cinch'
require 'google-search'

class Summon
  include Cinch::Plugin

  match(/summon (.+)/)
  def execute(m, query)
    image_results = Google::Search::Image.new(:query => query)
    m.reply(image_results.first.uri.to_s)
  end
end
