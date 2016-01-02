require 'spec_helper'

describe ConnectFour do
  let!(:new_game) { ConnectFour.new }
  let(:player_1) { Player.new("player", "X") }
  let(:player_2) { Player.new("player", "O")}

  describe '.new' do
    it 'makes a board' do
      expect(new_game.board).to be_a(Board)
    end

  end

  describe '#play_game' do
    # it "requires both players to give a name as input" do
    #   expect(STDIN).to receive(:gets).and_return('carl')
    #   expect(new_game.play_game).to output(/carl/).to_stdout
    # end
  end

end
