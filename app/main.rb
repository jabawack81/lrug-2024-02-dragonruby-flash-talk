# frozen_string_literal: true

require_relative "tic_tac_toe"

class Presentation
  WINDOW_WIDTH = 1280

  def initialize(args)
    @page = 0
    @args = args
  end

  def next_page
    $tic_tac_toe = nil
    @page += 1 if @page < (pages.length - 1)
  end

  def prev_page
    $tic_tac_toe = nil
    @page -= 1 if @page.positive?
  end

  def render_page
    @args.outputs.background_color = [255, 255, 255]
    current_page = pages[@page]
    current_page[:labels].each do |label|
      @args.outputs.labels << label
    end

    current_page[:sprites].each do |sprite|
      @args.outputs.sprites << sprite
    end
  end

  private

  def pages
    [
      title_page,
      features_0,
      features_1,
      features_2,
      features_3,
      how_it_works_0,
      how_it_works_1,
      how_it_works_2,
      how_it_works_3,
      tic_tac_toe_page
    ]
  end

  def title_page
    {
      labels: [
        title("Unleashing Creativity with DragonRuby:"),
        sub_title("A Modern Game Engine for Everyone"),
        { x: (WINDOW_WIDTH / 2), y: 50, anchor_x: 0.5, anchor_y: 0.5, text: "A talk by Paolo Fabbry" }
      ],
      sprites: [
        { x: (WINDOW_WIDTH - 630) / 2, y: 80, w: 630, h: 500, path: "/sprites/dragonruby_logo.png", angle: 0 }
      ]
    }
  end

  def features_0
    {
      labels: [
        title("Features"),
        bullet_point("* Zero Dependency Install", 0),
        sub_bullet_point("Download, unzip, edit", 0)
      ],
      sprites: []
    }
  end

  def features_1
    page = features_0
    page[:labels] << bullet_point("* Editor Agnostic", 1)
    page[:labels] << sub_bullet_point("BYOI (Bring Your Own IDE)", 1)
    page
  end

  def features_2
    page = features_1
    page[:labels] << bullet_point("* Cross Platform", 2)
    page[:labels] << sub_bullet_point(
      "PC, Mac, Linux, WASM, iOS, Android, Switch, XBOX One, and PS4", 2
    )
    page
  end

  def features_3
    page = features_2
    page[:labels] << bullet_point("* Lean, Fast, Hotloaded", 3)
    page[:labels] << sub_bullet_point("Only 3,5MB of battletested and optimised C code", 3)
    page
  end

  def how_it_works_0
    {
      labels: [title("How it works")],
      sprites: [
        { x: (WINDOW_WIDTH - 1131) / 2, y: 0, w: 1131, h: 650, path: "/sprites/init_sdl.png", angle: 0 }
      ]
    }
  end

  def how_it_works_1
    {
      labels: [title("How it works")],
      sprites: [
        { x: (WINDOW_WIDTH - 1131) / 2, y: 0, w: 1131, h: 650, path: "/sprites/init_mruby.png", angle: 0 }
      ]
    }
  end

  def how_it_works_2
    {
      labels: [title("How it works")],
      sprites: [
        { x: (WINDOW_WIDTH - 1131) / 2, y: 0, w: 1131, h: 650, path: "/sprites/game_loop.png", angle: 0 }
      ]
    }
  end

  def how_it_works_3
    {
      labels: [title("How it works")],
      sprites: [
        { x: (WINDOW_WIDTH - 1131) / 2, y: 0, w: 1131, h: 650, path: "/sprites/sample_game.png", angle: 0 }
      ]
    }
  end

  def tic_tac_toe_page
    if @page == 9
      $tic_tac_toe ||= TicTacToe.new
      $tic_tac_toe.args = @args
      $tic_tac_toe.tick
    end
    {
      labels: [],
      sprites: []
    }
  end

  def title(text)
    {
      x: (WINDOW_WIDTH / 2),
      y: 690,
      text: text,
      size_enum: 20,
      anchor_x: 0.5,
      anchor_y: 0.5
    }
  end

  def bullet_point(text, index)
    {
      x: 100,
      y: 600 - (index * 60),
      text: text,
      size_enum: 6
    }
  end

  def sub_bullet_point(text, index)
    {
      x: 140,
      y: 565 - (index * 60),
      text: text,
      size_enum: 2
    }
  end

  def sub_title(text)
    {
      x: (WINDOW_WIDTH / 2),
      y: 630,
      text: text,
      size_enum: 15,
      # alignment_enum: 1,
      anchor_x: 0.5,
      anchor_y: 0.5
    }
  end
end

def tick(args)
  args.state.presentation ||= Presentation.new(args)
  args.state.presentation.next_page if args.inputs.keyboard.key_up.right_arrow
  args.state.presentation.prev_page if args.inputs.keyboard.key_up.left_arrow
  args.state.presentation.render_page
  # args.outputs.labels  << [640, 540, 'Hello World!', 5, 1]
  # args.outputs.labels  << [640, 500, 'Docs located at ./docs/docs.html and 100+ samples located under ./samples', 5, 1]
  # args.outputs.labels  << [640, 460, 'Join the Discord server! https://discord.dragonruby.org', 5, 1]
  #
  # args.outputs.sprites << { x: 576,
  #                           y: 280,
  #                           w: 128,
  #                           h: 101,
  #                           path: 'dragonruby.png',
  #                           angle: args.state.tick_count }
  #
  # args.outputs.labels  << { x: 640,
  #                           y: 60,
  #                           text: './mygame/app/main.rb',
  #                           size_enum: 5,
  #                           alignment_enum: 1 }
end
