# frozen_string_literal: true

class GameBoard
  attr_reader :state
  def initialize
    @state = Array.new(3) { Array.new(3) }
  end

  def render
    @state.each_with_index do |row, col|
      row.each_with_index do |elem, index|
        print elem ? elem.to_s : ' '
        print '|' unless index == 2
        print "\n" if index == 2
      end
      puts '-+-+-' unless col == 2
    end
  end
  
  def changeState(row,col,symbol)
    @state[row][col] = symbol
  end
end

class Player
  attr_accessor :name, :symbol
  def initialize(name, symbol)
    self.name = name
    self.symbol = symbol
  end
end

class GameController
  @current_turn = nil
  @is_won = false
  attr_accessor :player_one, :player_two, :game_board, :is_won
  def initialize
    self.game_board = GameBoard.new()
    puts 'Tic-Tac-Toe! Why would you even play this!?'
    puts 'By Ordnas'
    puts "Enter player one's name"
    self.player_one = Player.new(gets.strip, 'X')
    puts "Enter player two's name"
    self.player_two = Player.new(gets.strip, 'O')
    @current_turn = rand > 0.5 ? player_one : player_two
    
    until is_won
      play_turn()
      check_win_condition()
      change_turn()
    end
  end

  private 
  def won
    @is_won = true
  end

  private
  def current_turn
    @current_turn
  end

  def change_turn
    @current_turn = current_turn == player_one ? player_two : player_one
  end

  private
  def play_turn
    puts "#{current_turn.name}, it's your turn"
    puts 'Please enter your move'
    self.game_board.render()

    input = gets.split(' ')
    until input.length == 2
      puts 'Invalid move, try again'
      input = gets.split(' ')
    end

    self.game_board.changeState(input[0].to_i, input[1].to_i, current_turn.symbol)
    self.game_board.render()
  end

  private
  def check_win_condition() 
    current_state = self.game_board.state
    current_state.each do |row|
      won if row.all?(current_turn.symbol)
    end

    for i in 0...current_state.length
      col = [current_state[0][i],current_state[1][i],current_state[2][i]]
      won if col.all?(current_turn.symbol)
    end

    diag_right = [current_state[2][0], current_state[1][1], current_state[0][2]]
    diag_left = [current_state[0][0], current_state[1][1], current_state[2][2]]

    won if diag_left.all?(current_turn.symbol) or diag_right.all?(current_turn.symbol)
    puts "player #{current_turn.symbol} won" if @is_won
  end
end

GameController.new()
