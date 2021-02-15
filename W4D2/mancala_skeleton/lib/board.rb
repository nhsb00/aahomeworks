require_relative "mancala"
require_relative "player"

class Board
  attr_accessor :cups

  def initialize(name1, name2)
    @name1 = name1
    @name2 = name2
    @cups = Array.new(14) {Array.new}
    place_stones
  end

  def place_stones
    # helper method to #initialize every non-store cup with four stones each
    @cups.each_with_index do |cup, idx|
      next if idx == 6 || idx == 13 # because 6 and 13 is current player, start empty
      4.times do 
        cup << :stone
      end
    end
  end

  def valid_move?(start_pos)
    raise 'Invalid starting cup' if start_pos < 0 || start_pos > 12
    raise 'Starting cup is empty' if @cups[start_pos].empty?
  end

  def make_move(start_pos, current_player_name)
    stones = @cups[start_pos]
    @cups[start_pos] = []

    cup_idx = start_pos
    until stones.empty?
      cup_idx += 1
      cup_idx = 0 if cup_idx > 13  # after 13 we should come back to position 0
      if cup_idx == 6
        @cups[6] << stones.pop if current_player_name == @name1
      elsif cup_idx == 13
        @cups[13] << stones.pop if current_player_name == @name2
      else
        @cups[cup_idx] << stones.pop
      end
    end

    render
    next_turn(cup_idx)
  end

  def next_turn(ending_cup_idx)
    # helper method to determine whether #make_move returns :switch, :prompt, or ending_cup_idx
    if ending_cup_idx == 6 || ending_cup_idx == 13
      :prompt   # can start choosing again
    elsif @cups[ending_cup_idx].count == 1
      :switch   # no stones was on the cup, so change player
    else 
      ending_cup_idx  # keep playing automatically
    end
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty? # do not include 6 and 13 becuase those are the place to store :S
                      # I will count 6 and 13 to have winner
    @cups[0...6].all? {|cup| cup.empty?} || @cups[7...13].all? {|cup| cup.empty?}
  end

  def winner
      player1_count = @cups[6].count
      player2_count = @cups[13].count

      if player1_count == player2_count
        :draw
      elsif player1_count > player2_count
        @name1
      elsif player1_count < player2_count
        @name2
      end
  end
end
