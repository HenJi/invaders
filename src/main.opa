import stdlib.web.canvas

body() =
  <div id="full">
    <canvas onready={_ -> OpaInvaders.init()} id="game_holder" width="1024" height="768">
        You can't see canvas, upgrade your browser !
    </canvas>
    <span id="debug"></span>
    <div id="prerender_area"></div>
  </>

server = Server.one_page_server("OpaInvaders", body)

css = css
#full {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}

#game_holder {
  position: fixed;
  top: 0;
  left: 0;
  overflow: hidden;
}

#prerender_area {
  display:none;
}

#debug {
  float:right;
}
