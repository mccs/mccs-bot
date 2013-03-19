require 'cinch'
require './lib/plugins/spoonerize/word.rb'

class Spoonerize
  include Cinch::Plugin

  match(/spoonerize (.+)/)
  def execute(m, phrase)
    words = phrase.split(' ').map{|w| Word.new(w)}
    m.reply(
      words
        .each_with_index
        .map{|word,i| words[i-1].head + word.tail }
        .join(' ')
    )
  end

end