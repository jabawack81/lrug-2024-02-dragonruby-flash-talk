# frozen_string_literal: true

class Presentation
  def initialize(args)
    @page = 0
    @args = args
  end

  def next_page
    @page += 1 if @page < (pages.length - 1)
  end

  def prev_page
    @page -= 1 if @page.positive?
  end

  def render_page
    current_page = pages[@page]
    @args.outputs.solids << {
      x: 0,
      y: 0,
      w: 1280,
      h: 720,
      r: 0,
      g: 80,
      b: 40,
      a: 255
    }

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
      page_2,
      page_3,
      page_4,
      page_5,
      page_6,
      page_7,
      page_8
    ]
  end

  def title_page
    {
      labels: [
        title("Unleashing Creativity with DragonRuby:"),
        sub_title("A Modern Game Engine for Everyone")
      ],
      sprites: [
        {
          x: 576,
          y: 280,
          w: 128,
          h: 101,
          path: "dragonruby.png",
          angle: 0
        }
      ]
    }
  end

  def page_2
    {
      labels: [title("dragonruby presentation page 2")],
      sprites: []
    }
  end

  def page_3
    {
      labels: [title("dragonruby presentation page 3")],
      sprites: []
    }
  end

  def page_4
    {
      labels: [title("dragonruby presentation page 4")],
      sprites: []
    }
  end

  def page_5
    {
      labels: [title("dragonruby presentation page 5")],
      sprites: []
    }
  end

  def page_6
    {
      labels: [title("dragonruby presentation page 6")],
      sprites: []
    }
  end

  def page_7
    {
      labels: [title("dragonruby presentation page 7")],
      sprites: []
    }
  end

  def page_8
    {
      labels: [title("dragonruby presentation page 8")],
      sprites: []
    }
  end

  def title(text)
    {
      x: 690,
      y: 690,
      text: text,
      size_enum: 15,
      # alignment_enum: 1,
      anchor_x: 0.5,
      anchor_y: 0.5
    }
  end

  def sub_title(text)
    {
      x: 690,
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
