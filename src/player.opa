@client Player = {{

  get_hitbox(p:OpaInvaders.player) = (
    p.position, 180,
    Models.player.width, Models.player.height
  )

  draw(ctx:Canvas.context, p:OpaInvaders.player, state) =
    (match state with
      | {death_pause=_} -> Models.player_explosion
      | _ -> Models.player)
    |> Models.draw_at(ctx,
         {x=p.position y=180}, _, Color.lime)

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
