@client game = Mutable.make(Default.game)

OpaInvaders = {{

  // Game area : 256x192
  fps = 60

  @client keyd(e) =
    g = game.get()
    key = e.key_code ? -1
    g = match key with
      | 37 -> // left
        {g with player={g.player with movement={left}}}
      | 39 -> // right
        {g with player={g.player with movement={right}}}
      | 32 -> // space
        match g.bullets.player with
        | {some=_} -> g
        | {none} ->
          bullets = {g.bullets with
            player=some({x=g.player.position+8 y=179})}
          {g with ~bullets}
        end
      | 80 -> // p
        g
      | _ -> g
    game.set(g)

  @client keyu(e) =
    g = game.get()
    key = e.key_code ? -1
    g = match (g.player.movement, key) with
      | ({left}, 37) -> // left
        {g with player={g.player with movement={none}}}
      | ({right}, 39) -> // right
        {g with player={g.player with movement={none}}}
      | _ -> g
    game.set(g)

  @client clean_frame(ctx:Canvas.context) =
    Canvas.clear_rect(ctx, 0, 0, 1024, 768)

  @client draw_bg(ctx, color) =
    do Canvas.set_fill_style(ctx, ~{color})
    do Canvas.fill_rect(ctx, 0, 0, 1024, 768)
    Canvas.restore(ctx)

  @client next_frame(ctx)() =
    /* Move the game */
    g = game.get()
      |> Invaders.move
      |> Player.move
      |> Bullets.move
      |> Explosions.consume
      |> Bullets.check

    /* Draw the game */
    do clean_frame(ctx)
    do draw_bg(ctx, Color.black)
    do Bullets.draw(ctx, g.bullets)
    do Invaders.draw(ctx, g.invaders)
    do Explosions.draw(ctx, g.explosions)
    do Player.draw(ctx, g.player)
    game.set(g)

  @client resize() =
    height = Dom.get_outer_height(#full)
    width = Dom.get_outer_width(#full)
    do Dom.void_style(#game_holder)
    if height > 3*width/4 then
      Dom.set_style(#game_holder, [
        {width={px=width}},
        {margin={t=some({px=(height-3*width/4)/2})
                 b=none l=none r=none}}
      ])
    else
      Dom.set_style(#game_holder, [
        {height={px=height}},
        {margin={l=some({px=(width-4*height/3)/2})
                 t=none b=none r=none}}
      ])

  @client init() =
    match Canvas.get(#game_holder) with
    | {none} -> void
    | {some=canvas} ->
      do resize()
      _ = Dom.bind(Dom.select_window(), {resize}, (_ -> resize()))
      ctx = Canvas.get_context_2d(canvas) |> Option.get
      t = Scheduler.make_timer(1000/fps, next_frame(ctx))
      bind_opts = [] // [{prevent_default}]
      _ = Dom.bind_with_options(Dom.select_document(), {keydown}, keyd, bind_opts)
      _ = Dom.bind_with_options(Dom.select_document(), {keyup}, keyu, bind_opts)
      t.start()

}}
