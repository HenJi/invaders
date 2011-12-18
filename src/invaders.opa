@client Invaders = {{

  get_position(squad_pos, ~{x y}) =
    dx = squad_pos.x
    dy = squad_pos.y
    {x=15*x+dx y=13*y+dy}

  draw(ctx:Canvas.context, i:OpaInvaders.invaders) =
    Map.iter(
      ~{x y}, inv ->
        model = Models.get_inv_model(inv, i.state)
        Models.draw_at(ctx,
          get_position(i.position, ~{x y}), model, Color.white),
      i.squad)

  line = 8

  move(g:OpaInvaders.game) =
    i = g.invaders
    loop = mod(i.loop+1, i.speed)
    (position, movement, sameline) =
      if loop != 0 then (i.position, i.movement, true)
      else
        cur = i.position
        match i.movement with
        | {left} ->
          lmin = 5 - i.first * 15
          if cur.x > lmin then
            ({x=cur.x-1 y=cur.y}, {left}, true)
          else
            ({x=cur.x y=cur.y+line}, {right}, false)
        | {right} ->
          rmax = 256 - (i.last+1) * 15 - 8 + 5
          if cur.x < rmax then
            ({x=cur.x+1 y=cur.y}, {right}, true)
          else
            ({x=cur.x y=cur.y+line}, {left}, false)
    max_y = 170 - 14 * i.lines
    position = {position with y=Int.min(max_y, position.y)}
    speed =
      if sameline then i.speed
      else Int.max(1, i.speed-2)
    state =
      if loop != 0 then i.state
      else match i.state with
        | {a} -> {b}
        | {b} -> {a}
    invaders = {i with ~speed ~position ~movement ~loop ~state}
    {g with ~invaders}

}}
