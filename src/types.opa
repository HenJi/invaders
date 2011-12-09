type OpaInvaders.game = {
  lives : int
  score : int
  player : OpaInvaders.player
  invaders : OpaInvaders.invaders
  bullets : OpaInvaders.bullets
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

type OpaInvaders.bullets = {
  player : option(pos)
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
  loop : int
  state : {a} / {b}
}
