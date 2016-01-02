require 'spec_helper'

describe Player do
  let(:carl) { Player.new("carl", "x") }

  describe ".new" do
    it "takes a name as a parameter" do
      expect(carl).to be_a(Player)
      expect(carl.name).to eq("carl")
    end

    it "takes a symbol as a parameter" do
      expect(carl.symbol).to eq("x")
    end

  end
end
