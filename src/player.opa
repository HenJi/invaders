@client Player = {{

  draw(ctx:Canvas.context, p:OpaInvaders.player) =
    Models.draw_at(ctx,
      {x=p.position y=180}, Models.player, Color.lime)

  move(g:OpaInvaders.game) =
    lmin = 5
    rmax = 235 // 256 - 16 - 5
    p = g.player
    position = match p.movement with
      | {none} -> p.position
      | {left} -> Int.max(lmin, p.position - 1)
      | {right} -> Int.min(rmax, p.position + 1)
    {g with player={p with ~position}}

}}
