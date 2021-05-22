require "byebug"
require_relative "./board.rb"

class Tile
    NEIGHBOR_POS = [[-1, -1],
    [-1,  0],
    [-1,  1],
    [ 0, -1],
    [ 0,  1],
    [ 1, -1],
    [ 1,  0],
    [ 1,  1]]
    attr_reader :revealed, :flagged, :bombed
    def initialize(board,pos)
        @bombed=false
        @revealed = false
        @flagged=false
        @board=board
        @pos=pos
    end

    def make_bomb
        @bombed=true
    end

    def reveal
        return self if @flagged;
        return self if @revealed;
        @revealed=true

        if !bombed && neighbor_bomb_count ==0
            neighbors.each {|tile| tile.reveal}
        end
    end

    def to_s_answer
        bombed ? 'X' : "_"

    end

    def to_s
        if @revealed==false && @flagged==false
            '*'
        elsif @bombed && @revealed==true
            'X'
        elsif @flagged && !@revealed
            'F'
        elsif @revealed
            neighbor_bomb_count==0 ? '_' : neighbor_bomb_count.to_s
        else
            ""
        end
    end


    def neighbor_bomb_count
        neighbors.select{|tile| tile.bombed}.count
    end

    def neighbors
        all_neighbors = NEIGHBOR_POS.map do |(x,y)|
            [@pos[0]+x, @pos[1]+y]
        end
        valid_neighbors=all_neighbors.select do |position|
            # debugger
            ((0...9).to_a.include? position[0]) && ((0...9).to_a.include? position[1]);
        end
        valid_neighbors.map {|pos| @board[pos]}
    end

    def toggle_flag
        @flagged = !flagged unless revealed;
    end
end