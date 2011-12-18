Infos = {{

  draw(ctx, g:OpaInvaders.game) =
    do Canvas.save(ctx)
    do Canvas.set_fill_style(ctx, {color=Color.black})
    do Canvas.fill_rect(ctx, 0, 0, 1024, 40)
    do Canvas.set_fill_style(ctx, {color=Color.white})
    do Canvas.fill_rect(ctx, 0, 10*4, 1024, 4)
    do if g.lives > 0 then
      Models.draw_at(ctx, {x=5 y=1}, Models.player, Color.lime)
    do if g.lives > 1 then
      Models.draw_at(ctx, {x=25 y=1}, Models.player, Color.lime)
    do if g.lives > 2 then
      Models.draw_at(ctx, {x=45 y=1}, Models.player, Color.lime)
    do Canvas.set_font(ctx, "bold 28px Arial")
    do Canvas.fill_text(ctx, "Score:", 800, 32)
    do Canvas.set_fill_style(ctx, {color=Color.lime})
    do Canvas.fill_text(ctx, "{g.score}", 800+Canvas.measure_text(ctx, "Score: "), 32)
    Canvas.restore(ctx)

}}
