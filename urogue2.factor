USING: kernel math math.rectangles opengl opengl.gl ui ui.gadgets ui.render
 game.input game.input.scancodes ui.pixel-formats sequences io ;
IN: urogue2

TUPLE: urogue-gadget < gadget { map initial: { } } { floor initial: 1 } timer ;

: reshape ( w h -- )
   [ 0 0 ] 2dip glViewport GL_PROJECTION glMatrixMode 
   GL_PROJECTION glMatrixMode
   glLoadIdentity
   -30.0 30.0 -30.0 30.0 -30.0 30.0 glOrtho
   GL_MODELVIEW glMatrixMode ;

: paint ( -- )
   0.0 0.0 0.0 0.0 glClearColor
   GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT bitor glClear
   GL_SMOOTH glShadeModel glLoadIdentity 
   GL_TRIANGLES glBegin 1.0 0.0 0.0 glColor3f
   0.0 0.0 0.0 glVertex3f 0.5 1.0 0.0 glVertex3f 1.0 0.0 0.0 glVertex3f glEnd glFlush ;

M: urogue-gadget pref-dim* drop { 1280 800 } ;
M: urogue-gadget draw-gadget* 
    rect-bounds nip first2 reshape paint ;

: urogue-window ( -- ) [ urogue-gadget new "Urogue 2" open-window ] with-ui ;
MAIN: urogue-window
