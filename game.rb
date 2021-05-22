require "byebug"
require_relative "./board.rb"
require "yaml"
#alias = Nam
class Game
    def initialize(size, num_bombs)
        @board=Board.new(size, num_bombs)
    end

    def play
        while !(@board.won? || @board.lost?)
            @board.render
            answer, pos = get_play()
            do_play(answer, pos)
        end
        @board.render_reveal

        if(@board.won?)
            puts "You won!"
        elsif(@board.lost?)
            puts "You lost!"
        end
    end

    def get_play
        puts "Actions: F, R, S"
        puts "Enter in 'action,x,y' format"
        answer = gets.chomp.split(",")
        [answer[0],[answer[1].to_i,answer[2].to_i]]
    end

    def do_play(action, pos)
        if(action=='F')
            @board[pos].toggle_flag
        elsif(action=='R')
            @board[pos].reveal
        elsif(action=='S')
            save()
        else
            puts "invalid command"
        end
    end
    
    def save
        File.write("saved",self.to_yaml)
        exit(0)
    end

end
if $PROGRAM_NAME == __FILE__
    ARGV.count==0? Game.new(9,10).play : YAML.load_file(ARGV.shift).play
end
# game = Game.new(9, 10)
# game.play