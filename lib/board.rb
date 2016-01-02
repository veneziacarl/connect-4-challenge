require 'pry'

class Board
attr_reader :gameboard, :piece_location, :valid_move

  def initialize
    @gameboard = []
    10.times do |col_index|
      gameboard[col_index] = []
      10.times do |row_index|
        gameboard[col_index][row_index] = nil
      end
    end
  end

  def valid_move?(column)
    gameboard[column][-1].nil?
  end

  def drop_piece(column, player)
    @piece_location = []
    @valid_move = false
    # while @valid_move == false
      gameboard[column].each_with_index do |square, index|
        if square.nil?
          gameboard[column][index] = player.symbol
          @piece_location << column
          @piece_location << index
          @valid_move = true
          return
          binding.pry
        elsif index == gameboard[column].length - 1
          puts "Invalid move, column is full - Try again!"
          @valid_move = false
        else
          @valid_move = false
        end

      end
    # end
  end

  def make_row(which_row)
    target_row = []
    gameboard.each do |column|
      target_row << column[which_row]
    end
    target_row
  end

  def make_columns(which_column)
    gameboard[which_column]
  end

  def make_diag_ascending(piece_location)
    diagonal_ascending = []
    least_number = piece_location[0] >= piece_location[1] ? piece_location[1] : piece_location[0]
    start_of_diagonal_column = piece_location[0] - least_number
    start_of_diagonal_row = piece_location[1] - least_number
    column_count = start_of_diagonal_column
    row_count = start_of_diagonal_row
    while column_count <= 9 && row_count <= 9
      diagonal_ascending << gameboard[column_count][row_count]
      column_count += 1
      row_count += 1
    end
    diagonal_ascending
  end

  def make_diag_descending(piece_location)
    diagonal_descending = []
    least_number = piece_location[0] >= piece_location[1] ? piece_location[1] : piece_location[0]
    start_of_diagonal_column = piece_location[0] - least_number
    start_of_diagonal_row = piece_location[1] + least_number
    column_count = start_of_diagonal_column
    row_count = start_of_diagonal_row
    while column_count <=9 && row_count >= 0
      diagonal_descending << gameboard[column_count][row_count]
      column_count += 1
      row_count -= 1
    end
    diagonal_descending
  end

  # def find_least_index(piece_location)
  #   least_number = piece_location[0] >= piece_location[1] ? piece_location[1] : piece_location[0]
  #   start_of_diagonal_column = piece_location[0] - least_number
  #   start_of_diagonal_row = piece_location[1] - least_number
  # end

  def count_consecutive(array)
    previous_piece = array[0]
    count = 0
    largest_count = 0
    array.each do |square|
      if square == previous_piece && square != nil
        count += 1
        largest_count = count unless largest_count > count
      else
        count = 1
      end
      previous_piece = square
    end
    largest_count
  end

  def winner?
    column = @piece_location[0]
    row = @piece_location[1]
    column_to_scan = make_columns(column)
    row_to_scan = make_row(row)
    ascending_diagonal_to_scan = make_diag_ascending(@piece_location)
    descending_diagonal_to_scan = make_diag_descending(@piece_location)
    row_consecutive = count_consecutive(row_to_scan)
    column_consecutive = count_consecutive(column_to_scan)
    ascending_diag_consecutive = count_consecutive(ascending_diagonal_to_scan)
    descending_diag_consecutive = count_consecutive(descending_diagonal_to_scan)

    winning_count = 4

    row_consecutive >= winning_count || column_consecutive >= winning_count || ascending_diag_consecutive >= winning_count || descending_diag_consecutive >= winning_count
  end

  def print_board
    final_output = ''
    current_row_index = make_row(0).length - 1
    while current_row_index >= 0
      current_row = make_row(current_row_index)
      string_row = make_print_row(current_row)
      final_output += make_ends(string_row)
      final_output += "\n"
      current_row_index -=1
    end
    final_output += make_bottom
    print final_output
  end

  def make_ends(string)
    output = "|" + string + "|"
  end

  def make_print_row(array)
    output = ""
    array.each do |square|
      output += square || " "
      output += " "
    end
    output.chop
  end

  def make_bottom
    output = " A B C D E F G H I J "
  end

end
