require 'spec_helper'

describe Board do
  let!(:board) { Board.new }
  let(:carl) { Player.new("carl", "X") }
  let(:jie) { Player.new("jie", "O")}

  describe ".new" do
    it "has a 10x10 board" do
      expect(board.gameboard.length).to eq(10)

      board.gameboard.each do |column|
        expect(column.length).to eq(10)
      end
    end

    it "is full of nil values" do
      board.gameboard.each do |column|
        column.each do |square|
          expect(square).to eq(nil)
        end
      end
    end
  end

  describe "#drop_piece" do
    it "drops a piece to the bottom of the column" do
      board.drop_piece(0, carl)
      expect(board.gameboard[0][0]).to eq("X")
      # board.object_id
      # binding.pry
    end

    it "drops a piece on top of a piece" do
      board.drop_piece(0, carl)
      board.drop_piece(0, jie)
      # board.object_id
      # binding.pry
      expect(board.gameboard[0][0]).to eq("X")
      expect(board.gameboard[0][1]).to eq("O")
      expect(board.gameboard[0][2]).to eq(nil)
    end

    it "returns the location of the dropped piece" do
      board.drop_piece(0, carl)
      expect(board.piece_location).to eq([0, 0])
      board.drop_piece(0, jie)
      expect(board.piece_location).to eq([0, 1])
    end

    it "does not drop the piece if the column is full" do
      5.times do
        board.drop_piece(8, carl)
        board.drop_piece(8, jie)
        expect(board.valid_move).to eq(true)
      end
      board.drop_piece(8, carl)

      expect(board.valid_move).to eq(false)
    end
  end

  describe "#make_diag_ascending" do
    it "correctly returns the diagonal of interest" do
      board.drop_piece(0, carl)
      board.drop_piece(0, jie)
      2.times do
        board.drop_piece(1, carl)
        board.drop_piece(1, jie)
      end
      3.times do
        board.drop_piece(3, carl)
        board.drop_piece(3, jie)
      end
      4.times do
        board.drop_piece(8, carl)
        board.drop_piece(8, jie)
      end
      board.drop_piece(8, carl)

      expect(board.make_diag_ascending(board.piece_location)).to eq(['X','O',nil,'O',nil,nil,nil,nil,'X',nil])
    end
  end

  describe "#make_diag_descending" do
    it "correctly returns the diagonal of interest" do
      board.drop_piece(0, carl)
      board.drop_piece(0, jie)
      2.times do
        board.drop_piece(1, carl)
        board.drop_piece(1, jie)
      end
      3.times do
        board.drop_piece(3, carl)
        board.drop_piece(3, jie)
      end
      4.times do
        board.drop_piece(8, carl)
        board.drop_piece(8, jie)
      end
      board.drop_piece(8, carl)
      2.times do
        board.drop_piece(4, carl)
        board.drop_piece(4, jie)
      end
      board.drop_piece(4, carl)

      expect(board.make_diag_descending(board.piece_location)).to eq([nil,nil,nil,'O','X',nil,nil,nil,'X'])
    end
  end

  describe "#count_consecutive" do
    it "counts consecutive pieces in an array" do
      expect(board.count_consecutive(["X", "O", "X", "X"])).to eq(2)
      expect(board.count_consecutive(["X", "O", "O", "X"])).to eq(2)
      expect(board.count_consecutive(['X','O',nil,'O','O',nil,nil,nil,'X',nil])).to eq(2)
    end
  end

  describe "#winner?" do
    it "evalutes winning player when 4 consecutive vertical pieces are found" do
      jie_wins = board
      4.times do
        jie_wins.drop_piece(0, jie)
      end

      expect(jie_wins.gameboard[0][0]).to eq("O")
      expect(jie_wins.gameboard[0][1]).to eq("O")
      expect(jie_wins.gameboard[0][2]).to eq("O")
      expect(jie_wins.gameboard[0][3]).to eq("O")

      expect(jie_wins.winner?).to eq(true)
    end

    it "neg winner test" do
      board.drop_piece(0, carl)
      board.drop_piece(0, jie)
      2.times do
        board.drop_piece(1, carl)
        board.drop_piece(1, jie)
      end
      3.times do
        board.drop_piece(3, carl)
        board.drop_piece(3, jie)
      end
      4.times do
        board.drop_piece(8, carl)
        board.drop_piece(8, jie)
      end
      board.drop_piece(8, carl)

      expect(board.winner?).to eq(false)
    end
  end

  describe "print_board" do
    it "prints an empty board" do

      empty_row = "|                   |\n"
      empty_board = empty_row * 10 + ' A B C D E F G H I J '

      expect{board.print_board}.to output(empty_board).to_stdout
    end

    it "prints a board with multiple pieces in a column" do
      jie_wins = board
      4.times do
        jie_wins.drop_piece(0, jie)
      end

      empty_row = "|                   |\n"
      test_board = empty_row * 6
      test_board += "|O                  |\n" * 4
      test_board += ' A B C D E F G H I J '

      expect{jie_wins.print_board}.to output(test_board).to_stdout
    end

    it "prints a board with multiple pieces in the same row" do
      second_board = board

      second_board.drop_piece(1, jie)
      second_board.drop_piece(2, jie)
      second_board.drop_piece(3, jie)
      second_board.drop_piece(4, jie)

      empty_row = "|                   |\n"
      test_board = empty_row * 9
      test_board += "|  O O O O          |\n"
      test_board += ' A B C D E F G H I J '

      expect{second_board.print_board}.to output(test_board).to_stdout
    end

    it "prints a board with pieces from different players all over the place" do
      board.drop_piece(0, carl)
      board.drop_piece(8, jie)
      board.drop_piece(0, carl)
      board.drop_piece(7, jie)
      board.drop_piece(2, carl)
      board.drop_piece(6, jie)
      board.drop_piece(8, carl)
      board.drop_piece(0, jie)
      board.drop_piece(0, carl)
      board.drop_piece(5, jie)

      empty_row = "|                   |\n"
      test_board = empty_row * 6
      test_board += "|X                  |\n"
      test_board += "|O                  |\n"
      test_board += "|X               X  |\n"
      test_board += "|X   X     O O O O  |\n"
      test_board += ' A B C D E F G H I J '

      expect{board.print_board}.to output(test_board).to_stdout
    end
  end

end
