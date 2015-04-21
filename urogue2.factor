USING: kernel math math.rectangles opengl opengl.gl ui ui.gadgets ui.render
 locals game.input game.input.scancodes ui.pixel-formats sequences io math.vectors
 accessors combinators timers calendar arrays ;
IN: urogue2

TUPLE: player pos ;
TUPLE: urogue-gadget < gadget { p initial: T{ player f { 0 0 } } }
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

:: right-side? ( a b pt -- ? )
    a b v- { { [ dup second 1.0 * 0.0 = ] [ drop pt second b second > ] }
             { [ dup first  1.0 * 0.0 = ] [ drop pt first a first > ] }
             [ first2 swap / a first pt first - * a second + pt first swap > ] }
    cond ;

:: draw-rect ( c p col center -- )
    col first3 glColor3f c [ first2 0 glVertex3f ] each glEnd
    GL_TRIANGLES glBegin c rest c first 1array append c
    ! the v- produces the magnitude of each axis
    ! find the slope of the two points. 
    
    [ 2dup 2dup p right-side? center swap [ right-side? ] dip = not
      [ 2dup 2dup v- [ abs ] map dup 0 [ + ] reduce dup 2array v/ :> n
        p v- first2 60 / n first * abs [ 62 / n second * abs ] dip + dup 0 glColor3f
        drop first2 0 glVertex3f p first2 0 glVertex3f first2 0 glVertex3f 1 1 ] when 
      2drop ]
    2each glEnd ;

: paint ( g -- )
   0.0 0.0 0.0 0.0 glClearColor
   GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT bitor glClear
   GL_SMOOTH glShadeModel glLoadIdentity
   dup dup p>> pos>> [ neg ] map first2 0.0 glTranslatef 
   GL_QUADS glBegin 1.0 0.0 0.0 glColor3f p>> draw-player 
   glEnd ! GL_TRIANGLES glBegin
   ! -8 0.0 0.0 glVertex3f 8 0 0 glVertex3f 4 p
   ! p>> pos>> dup dup dup
   ! dup first 2.5 <= [ { [ { 2.5 4 } v+ first 62 / abs dup 0.0 glColor3f ]
   !  [ drop -8 0 0 glVertex3f ] [ drop -8 -25.6 0 glVertex3f ] 
   !  [ { 2.5 4 } v+ first2 0 glVertex3f ] } cleave 1 ] when drop
   ! dup second -28.1 <= [ { [ { 2.5 4 } v+ second 60 / abs dup 0.0 glColor3f ]
   ! [ drop -8 -25.6 0 glVertex3f ] [ drop 8 -25.6 0 glVertex3f ] 
   !  [ { 2.5 4 } v+ first2 0 glVertex3f ] } cleave 1 ] when drop
   ! dup first 5.5 >= [ { [ { 2.5 4 } v+ first 62 / abs dup 0.0 glColor3f ]
   !  [ drop 8 -25.6 0 glVertex3f ] [ drop 8 0 0 glVertex3f ] 
   !  [ { 2.5 4 } v+ first2 0 glVertex3f ] } cleave 1 ] when drop
   ! dup second -4 >= [ { [ { 2.5 4 } v+ second 60 / abs dup 0.0 glColor3f ]
   !  [ drop -8 0 0 glVertex3f ] [ drop 8 0 0 glVertex3f ] 
   !  [ { 2.5 4 } v+ first2 0 glVertex3f ] } cleave 1 ] when drop

   GL_QUADS glBegin
   p>> pos>> { 2.5 4 } v+ { { -8 0 } { -8 -25.6 } { 8 -25.6 } { 8 0 } }
   swap { 1 1 0 } { 0 -12.8 } draw-rect

   ! Actually '60 / 16 * 1.6 *' and '62 / 16 *'
   ! 1.0 1.0 0 glColor3f
   ! -8 0 0 glVertex3f -8 -25.6 0 glVertex3f 8 -25.6 0 glVertex3f
   ! -8 0 0 glVertex3f 8 0 0 glVertex3f 8 -25.6 0 glVertex3f
   glFlush ;

:: assess ( g -- )
    read-keyboard keys>> :> k
    key-up-arrow k nth [ g p>> dup pos>> { 0 1.6 } v+ >>pos drop ] when
    key-down-arrow k nth [ g p>> dup pos>> { 0 -1.6 } v+ >>pos drop ] when
    key-left-arrow k nth [ g p>> dup pos>> { -1 0 } v+ >>pos drop ] when
    key-right-arrow k nth [ g p>> dup pos>> { 1 0 } v+ >>pos drop ] when ;

: tick ( g -- ) relayout-1 ;

M: urogue-gadget pref-dim* drop { 1280 800 } ;
M: urogue-gadget graft* 
    open-game-input [ [ tick ] curry 10 milliseconds every ] keep timer<< ;
M: urogue-gadget ungraft* [ stop-timer f ] change-timer drop ;
M: urogue-gadget draw-gadget* 
    dup dup rect-bounds nip first2 reshape assess paint ;

: urogue-window ( -- ) [ urogue-gadget new "Urogue 2" open-window ] with-ui ;
MAIN: urogue-window
