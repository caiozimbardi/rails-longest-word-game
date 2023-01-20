require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def score
    @attempt = params[:word]
    @grid = params[:letters]
    @start = Time.parse(params[:start_time])
    @end_time = Time.now
    @time = @end_time - @start
    @result = if check_word?(@attempt) == false
                { score: 0, message: 'This is not an english word', time: @time }
              elsif grid_inclusion(@attempt, @grid) == false
                { score: 0, message: 'Hey! a word was not in the grid!', time: @time }
              elsif @attempt.empty?
                { score: 0, message: 'You should type a word!', time: @time }
              else
                { score: (@attempt.length * 1000 * 1 / @time).round, message: 'Well Done!', time: @time }
              end
    @result
  end

  def new
    @letters = Array.new(9) { ('A'..'Z').to_a.sample }
    @start_time = [Time.now]
  end

  def check_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_attempt = URI.open(url).read
    user = JSON.parse(user_attempt)
    user["found"]
  end

  def grid_inclusion(attempt, grid)
    attempt.upcase.chars.all? do |letter|
      attempt.upcase.count(letter) <= grid.count(letter)
    end
  end
end
