USING: kernel math math.rectangles opengl opengl.gl ui ui.gadgets ui.render
 locals game.input game.input.scancodes ui.pixel-formats sequences io math.vectors
 accessors combinators ;
IN: urogue2

TUPLE: player pos ;
TUPLE: urogue-gadget < gadget { p initial: T{ player f { 0.5 0.5 } } }
 { map initial: { } } { floor initial: 1 } timer ;

: reshape ( w h -- )
   [ 0 0 ] 2dip glViewport GL_PROJECTION glMatrixMode 
   GL_PROJECTION glMatrixMode
   glLoadIdentity
   -30.0 30.0 -30.0 30.0 -30.0 30.0 glOrtho
   GL_MODELVIEW glMatrixMode ;

: draw-player ( p -- )
   pos>> { [ first2 0.0 glVertex3f ] [ { 5 0 } v+ first2 0.0 glVertex3f ]
           [ { 5 8 } v+ first2 0.0 glVertex3f ]
           [ { 0 8 } v+ first2 0.0 glVertex3f ] } cleave ;

: paint ( g -- )
   0.0 0.0 0.0 0.0 glClearColor
   GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT bitor glClear
   GL_SMOOTH glShadeModel glLoadIdentity 
   GL_QUADS glBegin 1.0 0.0 0.0 glColor3f p>> draw-player glEnd glFlush ;

M: urogue-gadget pref-dim* drop { 1280 800 } ;
M: urogue-gadget draw-gadget* 
    dup rect-bounds nip first2 reshape paint ;

: urogue-window ( -- ) [ urogue-gadget new "Urogue 2" open-window ] with-ui ;
MAIN: urogue-window
