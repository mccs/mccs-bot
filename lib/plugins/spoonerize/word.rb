class Word

  @@pattern = /[aeiou]+/i

  def head
    split > 0 ? @word[0..(split - 1)] : ''
  end

  def initialize(word)
    @word = word
  end

  def split
    @word.index(@@pattern) || 0
  end

  def tail
    @word[split..-1]
  end

end
