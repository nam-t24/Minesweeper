require "byebug"
require_relative "./tile.rb"

class Board
    def initialize(size, num_bombs)
        @size = size
        @num_bombs=num_bombs

        @grid = Array.new(@size) do |row|
            Array.new(@size) {|col| Tile.new(self, [row,col])}
        end

        plant_bombs
    end

    def [](pos)
        x,y=pos
        @grid[x][y]
    end

    def render(reveal = false)
        puts "  #{(0...9).to_a.join(" ")}"
        @grid.each_with_index do |row,i|
            join_row =row.map {|tile| reveal ? tile.to_s_answer : tile.to_s}
            puts "#{i} #{join_row.join(" ")}"
        end
    end

    def render_reveal
        render(true)
    end

    def won?
        # debugger
        @grid.flatten.all? {|tile| tile.bombed != tile.revealed}
    end

    def lost?
        @grid.flatten.any? {|tile| tile.bombed && tile.revealed}
    end

    def plant_bombs
        bomb_count=0
        while bomb_count < @num_bombs
            pos = Array.new(2) {rand(@size)}
            if (!self[pos].bombed)
                self[pos].make_bomb
                bomb_count+=1
            end
        end
        nil
    end

end