require 'cinch'
require 'google-search'

class Wat
    include Cinch::Plugin

    match(/wat/)
    def execute(m)
        image_results = Google::Search::Image.new(:query => 'wat')
        image_results = image_results.to_a
        image_results.shift
        m.reply(image_results.sample.uri.to_s)
    end
end
