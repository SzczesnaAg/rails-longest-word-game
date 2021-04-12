class GamesController < ApplicationController

  # The new action will be used to display a new random grid and a form
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  # The form will be submitted (with POST) to the score action.
  def score
    @attempt = params[:word]
    @letters_list = params[:letters]
    @not_in_grid = "Sorry but #{@attempt} can't be built out of #{@letters_list}"
    @not_english = "Sorry but #{@attempt} does not seem to be a valid English word..."
    @success = "Congratulation! #{@attempt} is a valid English word!"
    @result = nil

    @word_check = english_word(@attempt)

    if grid_include?(@attempt, @letters_list) && @word_check[:found]
      @result = @success
    elsif grid_include?(@attempt, @letters_list) == false
      @result = @not_in_grid
    elsif @word_check[:found] == false
      @result = @not_english
    end
  end

  private

  # check if in a grid
  def grid_include?(attempt, letters)
    letters = attempt.chars
    letters.all? { |letter| letters.include?(letter) }
  end

  # check if it is English word
  def english_word(attempt)
    url = "https://wagon-dictionary.herokuapp.com/apple"
    # Jason "https://wagon-dictionary.herokuapp.com/#{attempt}"
    raw_response = open(url).read
    JSON.parse(raw_response, symbolize_names: true)
  end
end
