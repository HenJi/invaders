@client Models = {{

  @private of_string(src) : list(pos) =
    String.explode("\n", src)
    |> List.filter(l -> l != "", _)
    |> List.mapi(
      y, l ->
        String.fold(
          c, (x, acc) ->
            acc = if c != " " then [~{x y}|acc] else acc
            (x+1, acc),
          l, (0, [])) |> _.f2,
      _)
    |> List.flatten

  pre_render(id:string, model:list(pos), color:color) =
    (width, height) = List.fold(
      ~{x y}, (xm, ym) ->
        (Int.max(xm,x+1), Int.max(ym,y+1)),
      model, (0,0))
    f() =
      match Canvas.get(#{id}) with
      | {none} -> jlog("no canvas ({id})")
      | {some=canvas} ->
        ctx = Canvas.get_context_2d(canvas) |> Option.get
        do Canvas.set_fill_style(ctx, ~{color})
        List.iter(
          ~{x y} -> Canvas.fill_rect(ctx, 4*x, 4*y, 4, 4),
          model)
    _ = <canvas id={id} height={4*height} width={4*width}
                onready={_ -> f()}></canvas>
      |> Dom.of_xhtml |> Dom.put_at_end(#prerender_area, _)
    ~{id width height}

  draw_at(ctx:Canvas.context, pos:pos, model, _:color) =
    match Canvas.get(#{model.id}) with
    | {none} -> jlog("no image ({model})")
    | {some=canvas} ->
      Canvas.draw_image(ctx, ~{canvas}, 4*pos.x, 4*pos.y)

  get_inv_model(t, state) =
    match (t, state) with
    | ({inv_a}, {a}) -> inv_a_a
    | ({inv_a}, {b}) -> inv_a_b
    | ({inv_b}, {a}) -> inv_b_a
    | ({inv_b}, {b}) -> inv_b_b
    | ({inv_c}, {a}) -> inv_c_a
    | ({inv_c}, {b}) -> inv_c_b

  inv_color = Color.white
  player_color = Color.green

inv_a_a = "
    0000    
 0000000000 
000000000000
000  00  000
000000000000
  000  000  
 00  00  00 
  00    00  
" |> of_string
  |> pre_render("inv_a_a", _, inv_color)

inv_a_b = "
    0000    
 0000000000 
000000000000
000  00  000
000000000000
   00  00   
  00 00 00  
00        00
" |> of_string
  |> pre_render("inv_a_b", _, inv_color)

inv_b_a = "
  0     0  
   0   0   
  0000000  
 00 000 00 
00000000000
00000000000
0 0     0 0
   00 00   
" |> of_string
  |> pre_render("inv_b_a", _, inv_color)

inv_b_b = "
  0     0  
0  0   0  0
0 0000000 0
000 000 000
00000000000
 000000000 
  0     0  
 0       0 
" |> of_string
  |> pre_render("inv_b_b", _, inv_color)

inv_c_a = "
   00   
  0000  
 000000
00 00 00
00000000
 0 00 0 
0      0
 0    0 
" |> of_string
  |> pre_render("inv_c_a", _, inv_color)

inv_c_b= "
   00   
  0000  
 000000
00 00 00
00000000
  0  0  
 0 00 0 
0 0  0 0
" |> of_string
  |> pre_render("inv_c_b", _, inv_color)

explosion = "
     0      
 0   0  0   
  0     0  0
   0   0  0 
00          
          00
 0  0   0   
0  0     0  
   0  0   0 
      0     
" |> of_string
  |> pre_render("explosion", _, Color.white)

alien = "
     000000     
   0000000000   
  000000000000  
 00 00 00 00 00 
0000000000000000
  000  00  000  
   0        0   
" |> of_string
  |> pre_render("alien", _, Color.red)

player = "
        0        
       000       
       000       
 000000000000000 
00000000000000000
00000000000000000
00000000000000000
00000000000000000
" |> of_string
  |> pre_render("player", _, player_color)

player_explosion = "
 0      0      0  
    0             
  0    0     0    
      0    0   0  
 0   00  0        
    000000000  0  
   00000000000    
00000000000000000  
" |> of_string
  |> pre_render("player_explosion", _, player_color)

bullet_a_1 = "
 0 
000
 0 
 0 
 0 
" |> of_string
  |> pre_render("bullet_a_1", _, Color.white)

bullet_a_2 = "
 0 
 0 
000
 0 
 0 
" |> of_string
  |> pre_render("bullet_a_2", _, Color.white)

bullet_a_3 = "
 0 
 0 
 0 
000
 0 
" |> of_string
  |> pre_render("bullet_a_3", _, Color.white)

bullet_a_4 = bullet_a_2

bullet_b_1 = "
 0 
  0
 0 
0  
 0 
" |> of_string
  |> pre_render("bullet_b_1", _, Color.white)

bullet_b_2 = "
0  
 0 
  0
 0 
0  
" |> of_string
  |> pre_render("bullet_b_2", _, Color.white)

bullet_b_3 = "
 0 
0  
 0 
  0
 0 
" |> of_string
  |> pre_render("bullet_b_3", _, Color.white)

bullet_b_4 = "
  0
 0 
0  
 0 
  0
" |> of_string
  |> pre_render("bullet_b_4", _, Color.white)

}}
