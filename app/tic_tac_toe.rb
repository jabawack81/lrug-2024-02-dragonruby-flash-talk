# frozen_string_literal: true

class TicTacToe
  attr_gtk # class macro that adds outputs, inputs, state, etc to class

  def tick
    init_new_game
    render_board
    input_board
  end

  def init_new_game
    state.current_turn       ||= :x
    state.space_combinations ||= [-1, 0, 1].product([-1, 0, 1]).to_a
    return if state.spaces

    state.square_size ||= 80
    state.board_left  ||= grid.w_half - (state.square_size * 1.5)
    state.board_top   ||= grid.h_half - (state.square_size * 1.5)
    state.spaces = {}
    state.space_combinations.each do |x, y|
      state.spaces[x]    ||= {}
      state.spaces[x][y] ||= {}
      state.spaces[x][y].hitbox ||= {
        x: state.board_left + ((x + 1) * state.square_size),
        y: state.board_top  + ((y + 1) * state.square_size),
        w: state.square_size,
        h: state.square_size
      }
    end
  end

  def render_board
    outputs.borders << all_spaces.map(&:hitbox)

    hovered_box = all_spaces.find do |space|
      inputs.mouse.inside_rect?(space.hitbox) && !space.piece
    end

    if hovered_box && !state.game_over
      args.outputs.solids << { x: hovered_box.hitbox.x,
                               y: hovered_box.hitbox.y,
                               w: hovered_box.hitbox.w,
                               h: hovered_box.hitbox.h,
                               r: 0,
                               g: 100,
                               b: 200,
                               a: 80 }
    end

    outputs.labels << filled_spaces.map do |space|
      { x: space.hitbox.x + (space.hitbox.w / 2),
        y: space.hitbox.y + (space.hitbox.h / 2),
        anchor_x: 0.5,
        anchor_y: 0.5,
        size_px: 40,
        text: space.piece }
    end

    # Uses a label to output whether x or o won, or if a draw occurred.

    # If the game is ongoing, a label shows whose turn it currently is.

    outputs.labels << if state.x_won

                        { x: 640, y: 600, text: "x won", size_px: 40, anchor_x: 0.5, anchor_y: 0.5 }

                      elsif state.o_won

                        { x: 640, y: 600, text: "o won", size_px: 40, anchor_x: 0.5, anchor_y: 0.5 }

                      elsif state.draw

                        { x: 640, y: 600, text: "draw", size_px: 40, anchor_x: 0.5, anchor_y: 0.5 }

                      else

                        { x: 640, y: 600, text: "turn: #{state.current_turn}", size_px: 40, anchor_x: 0.5,
                          anchor_y: 0.5 }

                      end
  end

  # Calls the methods responsible for handling user input and determining the winner.

  # Does nothing unless the mouse is clicked.

  def input_board
    return unless inputs.mouse.click

    input_place_piece

    input_restart_game

    determine_winner
  end

  # Handles user input for placing pieces on the board.

  def input_place_piece
    return if state.game_over

    # Checks to find the space that the mouse was clicked inside of, and makes sure the space does not already

    # have a piece in it.

    space = all_spaces.find do |space|
      inputs.mouse.click.point.inside_rect?(space.hitbox) && !space.piece
    end

    # The piece that goes into the space belongs to the player whose turn it currently is.

    return unless space

    space.piece = state.current_turn

    # This ternary operator statement allows us to change the current player's turn.

    # If it is currently x's turn, it becomes o's turn. If it is not x's turn, it become's x's turn.

    state.current_turn = state.current_turn == :x ? :o : :x
  end

  # Resets the game.

  def input_restart_game
    return unless state.game_over

    gtk.reset

    init_new_game
  end

  # Checks if x or o won the game.

  # If neither player wins and all nine squares are filled, a draw happens.

  # Once a player is chosen as the winner or a draw happens, the game is over.

  def determine_winner
    state.x_won = won? :x # evaluates to either true or false (boolean values)

    state.o_won = won? :o

    state.draw = true if filled_spaces.length == 9 && !state.x_won && !state.o_won

    state.game_over = state.x_won || state.o_won || state.draw
  end

  # Determines if a player won by checking if there is a horizontal match or vertical match.

  # Horizontal_match and vertical_match have boolean values. If either is true, the game has been won.

  def won?(piece)
    # performs action on all space combinations

    won = [[-1, 0, 1]].product([-1, 0, 1]).map do |xs, y|
      # Checks if the 3 grid spaces with the same y value (or same row) and

      # x values that are next to each other have pieces that belong to the same player.

      # Remember, the value of piece is equal to the current turn (which is the player).

      horizontal_match = state.spaces[xs[0]][y].piece == piece &&

                         state.spaces[xs[1]][y].piece == piece &&

                         state.spaces[xs[2]][y].piece == piece

      # Checks if the 3 grid spaces with the same x value (or same column) and

      # y values that are next to each other have pieces that belong to the same player.

      # The && represents an "and" statement: if even one part of the statement is false,

      # the entire statement evaluates to false.

      vertical_match = state.spaces[y][xs[0]].piece == piece &&

                       state.spaces[y][xs[1]].piece == piece &&

                       state.spaces[y][xs[2]].piece == piece

      horizontal_match || vertical_match # if either is true, true is returned
    end

    # Sees if there is a diagonal match, starting from the bottom left and ending at the top right.

    # Is added to won regardless of whether the statement is true or false.

    won << (state.spaces[-1][-1].piece == piece && # bottom left

            state.spaces[0][0].piece == piece && # center

            state.spaces[1][1].piece == piece)   # top right

    # Sees if there is a diagonal match, starting at the bottom right and ending at the top left

    # and is added to won.

    won << (state.spaces[1][-1].piece == piece && # bottom right

            state.spaces[0][0].piece == piece && # center

            state.spaces[-1][1].piece == piece) # top left

    # Any false statements (meaning false diagonal matches) are rejected from won

    won.reject_false.any?
  end

  # Defines filled spaces on the board by rejecting all spaces that do not have game pieces in them.

  # The ! before a statement means "not". For example, we are rejecting any space combinations that do

  # NOT have pieces in them.

  def filled_spaces
    all_spaces.select(&:piece) # reject spaces with no pieces in them
  end

  # Defines all spaces on the board.

  def all_spaces
    state.space_combinations.map do |x, y|
      state.spaces[x][y] # yield if a block is given
    end
  end
end
