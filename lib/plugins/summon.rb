require 'cinch'
require 'google-search'

class Summon
  include Cinch::Plugin

  match(/summon (.+)/, method: :single_summon)
  def single_summon(m, query)
    image_results = Google::Search::Image.new(:query => query)
    m.reply(image_results.first.uri.to_s)
  end

  match(/resummon (.+)/, method: :resummon)
  def resummon(m, query)
    image_results = Google::Search::Image.new(:query => query)
    image_results.to_a.shift
    m.reply(image_results.sample.uri.to_s)
  end
end
