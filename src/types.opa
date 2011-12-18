type OpaInvaders.game = {
  lives : int
  score : int
  player : OpaInvaders.player
  invaders : OpaInvaders.invaders
  bullets : OpaInvaders.bullets
  explosions : list(OpaInvaders.explosion)
}

type OpaInvaders.explosion_type =
    { simple }

type OpaInvaders.explosion = {
  ex_type : OpaInvaders.explosion_type
  lifespan : int
  pos : pos
}

type OpaInvaders.player = {
  position : int
  movement : {left} / {right} / {none}
}

type OpaInvaders.invader =
    { inv_a } // 10 pts
  / { inv_b } // 20 pts
  / { inv_c } // 40 pts

type pos = {
  x : int
  y : int
}

type OpaInvaders.inv_bullet_t =
    { b_a }
  / { b_b }

type OpaInvaders.inv_bullet = {
  b_type : OpaInvaders.inv_bullet_t
  pos : pos
  anim : int
}

type OpaInvaders.bullets = {
  player : option(pos)
  inv : list(OpaInvaders.inv_bullet)
}

type OpaInvaders.invaders = {
  // Game value
  squad : map(pos, OpaInvaders.invader)
  speed : int
  position : pos
  movement : {left} / {right}

  // Engine value
  first : int // first populated column
  last : int // last populated column
  lines : int
  loop : int
  state : {a} / {b}
}
