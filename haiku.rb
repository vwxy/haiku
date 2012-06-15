#!/usr/bin/env ruby
require 'debugger'

def create_syllable_file
  lines = File.read('/Users/vera/nltk_data/corpora/cmudict/cmudict').split(/\n/)
  d = lines.inject({}) do |d,line|
    cols = line.split(' ')
    word = cols.shift.downcase
    cols.shift
    sylcount = cols.inject(0) do |sum,syl|
      if /.*\d$/.match syl
        sum + 1
      else
        sum
      end
    end
    d[word] = sylcount
    d
  end
  File.open('dictionary.txt','w') do |f|
    d.keys.each {|k| f.write "#{k} #{d[k]}\n"}
  end
  d
end

def create_syllable_dictionary
  if File.exists? 'dictionary.txt'
    File.read('dictionary.txt').split(/\n/).inject({}) do |d,line|
      cols = line.split(' ')
      d[cols[0]] = cols[1].to_i
      d
    end
  else
    create_syllable_file
  end
end

def haiku(syllables_by_line)
  d = create_syllable_dictionary
  poem = []
  syllables_by_line.each do |num_syllables|
    syllables = 0
    phrase = []
    while syllables<num_syllables
      word = d.keys[rand(d.size)]
      if d[word]<=(num_syllables-syllables)
        phrase << word
        syllables += d[word]
      end
    end
    poem << phrase
  end
  poem.map {|k| k.join(' ')+"\n"}
end

puts haiku([5,7,5])
