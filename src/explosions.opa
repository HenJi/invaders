@client Explosions = {{

  draw(ctx, explosions:list(OpaInvaders.explosion)) =
    List.iter(
      ex ->
        model = match ex.ex_type with
          { simple } -> Models.explosion
        Models.draw_at(ctx, ex.pos, model, Color.yellow),
      explosions)

  consume(g:OpaInvaders.game) =
    explosions = List.filter_map(
      ex ->
        if ex.lifespan < 1 then none
        else some({ex with lifespan=ex.lifespan-1}),
      g.explosions)
    {g with ~explosions}

}}
