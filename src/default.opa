Default = {{

  squad =
    [ List.init(i -> ({x=i y=0}, {inv_c}), 11),
      List.init(i -> ({x=i y=1}, {inv_b}), 11),
      List.init(i -> ({x=i y=2}, {inv_b}), 11),
      List.init(i -> ({x=i y=3}, {inv_a}), 11),
      List.init(i -> ({x=i y=4}, {inv_a}), 11),
    ] |> List.flatten |> Map.From.assoc_list

  invaders = {
    ~squad
    speed = 20
    position = {x=40 y=25}
    movement = {right}
    first = 0
    last = 10
    lines = 4
    loop = 0
    state = {a}
  } : OpaInvaders.invaders

  player = {
    position = 120
    movement = {none}
  } : OpaInvaders.player

  bullets = {
    player = none
    inv = []
  } : OpaInvaders.bullets

  game = {
    lives = 3
    score = 0
    ~player ~invaders ~bullets
  } : OpaInvaders.game

}}
