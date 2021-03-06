Bullets = {{

  anim_frames = 4

  draw(ctx:Canvas.context, b:OpaInvaders.bullets) =
    do match b.player with
      | {none} -> void
      | {some=pos} ->
        do Canvas.save(ctx)
        do Canvas.set_fill_style(ctx, {color=Color.white})
        do Canvas.fill_rect(ctx, 4*pos.x, 4*pos.y, 4, 16)
        Canvas.restore(ctx)
    do List.iter(
      bullet ->
        model = match (bullet.b_type, bullet.anim/anim_frames) with
          | ({b_a}, 0) -> Models.bullet_a_1
          | ({b_a}, 1) -> Models.bullet_a_2
          | ({b_a}, 2) -> Models.bullet_a_3
          | ({b_a}, _) -> Models.bullet_a_4
          | ({b_b}, 0) -> Models.bullet_b_1
          | ({b_b}, 1) -> Models.bullet_b_2
          | ({b_b}, 2) -> Models.bullet_b_3
          | ({b_b}, _) -> Models.bullet_b_4
        pos = {
          x = bullet.pos.x - model.width/2
          y = bullet.pos.y - model.height + 1
        }
        Models.draw_at(ctx, pos, model, Color.white),
      b.inv)
    void

  move(g:OpaInvaders.game) =
    player = match g.bullets.player with
      | {none} -> none
      | {some=pos} ->
        if pos.y < 0 then none
        else some({pos with y=pos.y-3})
    inv = List.filter_map(
      bullet ->
        if bullet.pos.y > 190 then none
        else
          anim = mod(bullet.anim+1, 4*anim_frames)
          pos = {bullet.pos with y=bullet.pos.y+1}
          some({bullet with ~anim ~pos}),
      g.bullets.inv)
    bullets = {g.bullets with ~player ~inv}
    {g with ~bullets}

  check_hit(pos, (x:int, y:int, w:int, h:int)) =
    pos.x > x && pos.x < x+w && pos.y > y && pos.y < y+h

  check(g:OpaInvaders.game) =
    g = match g.bullets.player with
      | {none} -> g
      | {some=pos} ->
        i = g.invaders
        hit_big = check_hit(pos, Invaders.get_squad_box(g.invaders))
        hit =
          if hit_big then
            Map.fold(
              rpos, inv, hit ->
                if Option.is_some(hit) then hit
                else
                  model = Models.get_inv_model(inv, i.state)
                  ~{x y} = Invaders.get_position(i.position, rpos)
                  if check_hit(pos, (x, y, model.width, model.height)) then
                    some(rpos)
                  else none,
              i.squad, none)
          else none
        match hit with
        | {none} -> g
        | {some=dead} ->
          (squad, d) = Map.extract(dead, i.squad)
          points = match d with
            | {some={inv_a}} -> 10
            | {some={inv_b}} -> 20
            | {some={inv_c}} -> 40
            | _ -> 0
          score = g.score + points
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
          lines = if dead.y != i.lines then i.lines
            else
              Map.fold(
                p, _, max -> Int.max(p.y, max),
                squad, 0)
          invaders = {i with ~squad ~first ~last ~lines}
          bullets = {g.bullets with player=none}
          explosions =
            new = {ex_type={simple} lifespan=20
                   pos=Invaders.get_position(invaders.position, dead)}
            [new|g.explosions]
          {g with ~invaders ~bullets ~explosions ~score}
        end
    p_hitbox = Player.get_hitbox(g.player)
    p_hit = List.fold(
      b, res -> check_hit(b.pos, p_hitbox) || res,
      g.bullets.inv, false)
    g =
      if p_hit then
        lives = g.lives - 1
        if lives < 0 then
          {g with state = {game_over}}
        else
          {g with ~lives
            bullets = Default.bullets
            state = {death_pause=60}}
      else g
    g

}}
