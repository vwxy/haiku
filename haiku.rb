#!/usr/bin/env ruby
require 'trollop'

opts = Trollop::options do
  opt :syl, "list of syllables by line", :default => [5,7,5]
end

CMUDICT_PATH = '~/nltk_data/corpora/cmudict/cmudict'

def create_syllable_file
  lines = File.read(CMUDICT_PATH).split(/\n/)
  d = lines.inject({}) do |d,line|
    cols = line.split(' ')
    word = cols.shift.downcase
    cols.shift  # ignore second column
    syllable_count = cols.inject(0) do |sum,syl|
      /.*\d$/.match(syl) ? sum + 1 : sum
    end
    d[word] = syllable_count
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

puts haiku(opts[:syl])
