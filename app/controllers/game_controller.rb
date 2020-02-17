require 'open-uri'
require 'json'

class GameController < ApplicationController
  def new
    @new_letters = []
    10.times do
      @new_letters << ('A'..'Z').to_a.sample
    end
    @new_letters
  end

  def score
    url = open("https://wagon-dictionary.herokuapp.com/" + params[:word]).read
    @word = JSON.parse(url)
    @result = {
      time: Time.now
    }
    if in_the_grid?(params[:word], params[:letters]) && @word["found"]
      @result[:score] = @word["length"]
      @result[:message] = "Well Done!"
    elsif @word["found"]
      @result[:score] = 0
      @result[:message] = "Not in the grid."
    else
      @result[:score] = 0
      @result[:message] = "Not an english word."
    end
    @result
  end

  def create_letter_frequencies(str)
    letter_freq = {}

    str.chars.each do |letter|
      if letter_freq.key?(letter)
        letter_freq[letter] += 1
      else
        letter_freq[letter] = 1
      end
    end

    return letter_freq
  end

  def in_the_grid?(a_string, array)
    # TODO: implement the improved method
    freq1 = create_letter_frequencies(a_string.upcase)
    freq2 = create_letter_frequencies(array.gsub(/\W/, ""))
    in_the_grid = true
    freq1.each do |letter, count|
      unless freq2.key? letter
        in_the_grid = false
        return in_the_grid
      end
      if count > freq2[letter]
        in_the_grid = false
        return in_the_grid
        break
      end
    end
    return in_the_grid
  end
end
