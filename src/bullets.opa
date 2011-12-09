Bullets = {{

  draw(ctx:Canvas.context, b:OpaInvaders.bullets) =
    do match b.player with
      | {none} -> void
      | {some=pos} ->
        do Canvas.save(ctx)
        do Canvas.set_fill_style(ctx, {color=Color.white})
        do Canvas.fill_rect(ctx, 4*pos.x, 4*pos.y, 4, 16)
        Canvas.restore(ctx)
    void

  move(g:OpaInvaders.game) =
    player = match g.bullets.player with
      | {none} -> none
      | {some=pos} ->
        if pos.y < 0 then none
        else some({pos with y=pos.y-3})
    bullets = {g.bullets with ~player}
    {g with ~bullets}

  check_hit(pos, x:int, y:int, w:int, h:int) =
    pos.x > x && pos.x < x+w && pos.y > y && pos.y < y+h

  check(g:OpaInvaders.game) =
    g = match g.bullets.player with
      | {none} -> g
      | {some=pos} ->
        i = g.invaders
        hit = Map.fold(
          rpos, inv, hit ->
            if Option.is_some(hit) then hit
            else
              model = Models.get_inv_model(inv, i.state)
              ~{x y} = Invaders.get_position(i.position, rpos)
              if check_hit(pos, x, y, model.width, model.height) then
                some(rpos)
              else none,
          i.squad, none)
        match hit with
        | {none} -> g
        | {some=dead} ->
          squad = Map.remove(dead, i.squad)
          first = if dead.x != i.first then i.first
            else
              Map.fold(
                p, _, min -> Int.min(p.x, min),
                squad, i.last)
          last = if dead.x != i.last then i.last
            else
              Map.fold(
                p, _, max -> Int.max(p.x, max),
                squad, i.first)
          do Dom.transform([#debug <- "{first} - {last}"])
          invaders = {i with ~squad ~first ~last}
          bullets = {g.bullets with player=none}
          {g with ~invaders ~bullets}
        end
    g

}}
