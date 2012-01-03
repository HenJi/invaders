@client Invaders = {{

  x_sep = 15
  y_sep = 13

  get_position(squad_pos, ~{x y}) =
    dx = squad_pos.x
    dy = squad_pos.y
    {x=x_sep*x+dx y=y_sep*y+dy}

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
    if loop != 0 then {g with ~invaders}
    else fire({g with ~invaders})

  fire(g:OpaInvaders.game) =
    try_fire() =
      proba = 500*g.invaders.speed
      Random.int(proba) == proba/2
    new_bullets = Map.fold(
      pos_in_squad, invader, acc ->
        if try_fire() then
          b_type = if Random.int(2) == 1 then {b_a} else {b_b}
          model = Models.get_inv_model(invader, g.invaders.state)
          p = get_position(g.invaders.position, pos_in_squad)
          pos = {x=p.x+model.width/2 y=p.y+model.height}
          [{~b_type ~pos anim=0}|acc]
        else acc,
      g.invaders.squad, [])
    {g with bullets =
      {g.bullets with inv=List.append(new_bullets, g.bullets.inv)}}

}}
