.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
.global checkRange
.global calcular_pixel
.global paint_pixel
.global rectangle
.global paint_pixel_cond
.global background
.global rectangleDegrade
.global animacionloop
.global boomAnimacion

checkRange:
//params: x3 = x coord,  x4= y coord
sub SP, SP, 8 						
stur X30, [SP, 0]	

    mov x25, SCREEN_WIDTH
    mov x26, SCREEN_HEIGH       //me traigo los valores a compararar para el rango

    cmp x3, xzr
        b.lt addWidth
    cmp x25, x3
        b.lt subWidth
    cmp x4, xzr
        b.lt addHeigh
    cmp x26, x4
        b.lt subHeigh

    b endrange

    addWidth:
        add x3, x3, SCREEN_WIDTH
        cmp x3, xzr
            b.lt addWidth
    
    subWidth:
        sub x3, x3, SCREEN_WIDTH
        cmp x25, x3
            b.lt subWidth
    
    addHeigh:
        add x4, x4, SCREEN_HEIGH
        cmp x4, xzr
            b.lt addHeigh
    
    subHeigh:
        sub x4, x4, SCREEN_HEIGH
        cmp x26, x4
            b.lt subHeigh
    
    endrange:


ldr X30, [SP, 0]				 			
add SP, SP, 8	
ret
//--FIN CHECK_RANGE--//

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//--INICIO CALCULAR_PIXEL--//
calcular_pixel: 
//params: x3 = coord x, x4 = coord y, returns the pointer to the framebuffer in that coord in x0
sub SP, SP, 8 						
stur X30, [SP, 0]	

    bl checkRange  //chequea si las coordenadas estan dentro del rango posible para el framebuffer, si no, las corrige

    mov x0, 640							// x0 = 640.
	mul x0, x0, x4						// x0 = 640 * y.		
	add x0, x0, x3						// x0 = (640 * y) + x.
	lsl x0, x0, 2						// x0 = ((640 * y) + x) * 4.
	add x0, x0, x20						// x0 = ((640 * y) + x) * 4 + framebuffer[0]

ldr X30, [SP, 0]					 			
add SP, SP, 8	
ret
//--FIN CALCULAR_PIXEL--//

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//--INICIO PAINT_PIXEL--//
paint_pixel:
//parametros, x3 = x coord, x4 = y coord, w10 = colour;
sub SP, SP, 8 						
stur X30, [SP, 0]

    bl calcular_pixel
    stur w10,[x0]  // Colorear el pixel N

ldr X30, [SP, 0]					 			
add SP, SP, 8	
ret
//--FIN PAINT_PIXEL--//

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//--INICIO DEL RECTANGULO--//
rectangle:
//parametros: x1 = Width, x2 = Heigh, x3= initial x, x4 = initial y, w10 = color
sub SP, SP, 8 						
stur X30, [SP, 0]

    mov x13, x3     //me guardo en x13, la coordenada x inicial de cada fila
    mov x9, x2      //contador de altura
    rectangleLoop:
        mov x3, x13 //restauro la coordenada x
        mov x11, x1 //contador de ancho
        rectanglePaint:
            bl paint_pixel //pinto el pixel
            add x3, x3, 1   //avanzo al de la derecha
            sub x11, x11, 1 //resto el contador de anchos
            cbnz x11, rectanglePaint //si no llegue al final, vuelvo a pintar
            add x4, x4, 1      //bajo al pixel de abajo
            sub x9, x9, 1    //resto el contador de altura
            cbnz x9, rectangleLoop  //si no llegue al final, vuelvo a empezar
ldr X30, [SP, 0]					 			
add SP, SP, 8	
ret

//--FIN DEL RECTANGULO--//

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

background:
//parametros: w10 = color del fondo, w11 = decremento del color
    sub sp, sp, 8
    stur x30, [sp, 0]
    mov x1, SCREEN_WIDTH     //todo el ancho de la pantalla
    mov x2, SCREEN_HEIGH    //toda la altura de la pantalla
    mov x3, 0               
    mov x4, 0               //coordenada 0,0
    bl rectangleDegrade

    /*background textures   */

    /*texturas del primer color -edificios-   */
    mov x1, 10 
    mov x2, 20 
    mov x3, 120
    mov x4, 150
    movz x10, 0x0003, lsl 16
    movk x10, 0x1723, lsl 00
    bl rectangle
    mov x1, 20
    mov x2, 10
    mov x3, 200
    mov x4, 150
    bl rectangle
    mov x1, 30
    mov x2, 10
    mov x3, 90
    mov x4, 150
    bl rectangle
    mov x1, 15
    mov x2, 15
    mov x3, 280
    mov x4, 150

    
    //bl rectangle
    mov x1, 15
    mov x2, 10
    mov x3, 360
    mov x4, 150
    //bl rectangle
    mov x1, 15
    mov x2, 15
    mov x3, 410
    mov x4, 150
    bl rectangle
    mov x1, 15
    mov x2, 15
    mov x3, 480
    mov x4, 150
    //bl rectangle
    mov x1, 20
    mov x2, 70
    mov x3, 0
    mov x4, 230
    bl rectangle
    mov x1, 40
    mov x2, 80
    mov x3, 0
    mov x4, 150
    bl rectangle
    mov x1, 60
    mov x2, 15
    mov x3, 30
    mov x4, 150
    bl rectangle
    mov x1, 30
    mov x2, 40
    mov x3, 620
    mov x4, 150
    bl rectangle
    mov x1, 80
    mov x2, 10
    mov x3, 560
    mov x4, 150
    bl rectangle

    /*texturas del segundo color  */
    movz x10, 0x0004, lsl 16
    movk x10, 0x2D39, lsl 00

    mov x1, 70
    mov x2, 30
    mov x3, 430
    mov x4, 130
    bl rectangle
    mov x1, 70
    mov x2, 50
    mov x3, 230
    mov x4, 110
    bl rectangle

    /*ventanas */ 


   

    /* espeacio entre edifcios */
    movz x10, 0x0003, lsl 16
    movk x10, 0x1723, lsl 00
    mov x1,20 
    mov x2, 50
    mov x3, 20
    mov x4, 230
    bl rectangle

    mov x1, 80
    mov x2, 140
    mov x3, 40
    mov x4, 130
    bl rectangle

    mov x1, 30
    mov x2, 150
    mov x3, 200
    mov x4, 130
    bl rectangle

    mov x1, 35
    mov x2, 150
    mov x3, 300
    mov x4, 130
    bl rectangle

    mov x1, 20
    mov x2, 150
    mov x3, 410
    mov x4, 130
    bl rectangle

    mov x1, 65
    mov x2, 150
    mov x3, 500
    mov x4, 130
    bl rectangle

    mov x1, 20
    mov x2, 150
    mov x3, 620
    mov x4, 130
    bl rectangle



    /* lineas divisoras*/ 

    movz x10, 0x0003, lsl 16
    movk x10, 0x1723, lsl 00
    mov x1, 640
    mov x2, 10
    mov x3, 0
    mov x4, 300
    bl rectangle

    movz x10, 0xFFFF, lsl 16
    movk x10, 0xFFFF, lsl 00
    mov x1, 640
    mov x2, 2
    mov x3, 0
    mov x4, 310
    bl rectangle


    movz x10, 0x0014, lsl 16
    movk x10, 0x2204, lsl 00
    mov x1, 10
    mov x2, 10
    mov x3, 0
    mov x4, 270
    bl rectangle
    mov x1, 25
    mov x2, 10
    mov x3, 0
    mov x4, 280
    bl rectangle
    mov x1, 35
    mov x2, 10
    mov x3, 0
    mov x4, 290
    bl rectangle

    mov x1, 10
    mov x2, 10
    mov x3, 630
    mov x4, 270
    bl rectangle
    mov x1, 25
    mov x2, 10
    mov x3, 615
    mov x4, 280
    bl rectangle
    mov x1, 35
    mov x2, 10
    mov x3, 605
    mov x4, 290
    bl rectangle
    

    ldr x30, [sp, 0]
    add sp, sp, 8

ret
//--FIN DEL FONDO--//
endgame:

rectangleDegrade:
//parametros: x1 = Width, x2 = Heigh, x3= initial x, x4 = initial y, w10 = color, w11 = decremento del color
sub SP, SP, 8 						
stur X30, [SP, 0]
    mov x15 , 0    //contador de color
    mov x13, x3     //me guardo en x13, la coordenada x inicial de cada fila
    mov x9, x2      //contador de altura
    rectangleDegradeLoop:
        mov x3, x13 //restauro la coordenada x
        mov x11, x1 //contador de ancho
        rectangleDegradePaint:
            bl paint_pixel //pinto el pixel
            add x3, x3, 1   //avanzo al de la derecha
            sub x11, x11, 1 //resto el contador de anchos
            cbnz x11, rectangleDegradePaint //si no llegue al final, vuelvo a pintar
            add x15, x15, 1   
            add x4, x4, 1      //bajo al pixel de abajo
            sub x9, x9, 1    //resto el contador de altura
            cmp x15, 150
            beq changecolor1
            cmp x15,300
            beq changecolor2
            cbnz x9, rectangleDegradeLoop  //si no llegue al final, vuelvo a empezar
ldr X30, [SP, 0]					 			
add SP, SP, 8	
ret
changecolor1:
    movz x10, 0x0004, lsl 16
    movk x10, 0x2D39, lsl 00
    b rectangleDegradeLoop
changecolor2:
    movz x10,0x002D, lsl 16
    movk x10,0x5D6D, lsl 00
    b rectangleDegradeLoop

animacionloop: 
// params : x1= ancho del barco , x2 alto del barco 
// x3 = coordenada x inicial , x4 = coordenada y inicial PRIMER BARCO
// x14 = coordenada x inicial , x15 = coordenada y inicial SEGUNDO BARCO
    
    
    sub sp, sp, 16
    stp x29, x30, [sp, 0]  // Guarda x29 y x30 en la pila
    add x29, sp, 8         // Actualiza el marco de pila
    stp x3, x4, [sp, 8]     // Guarda x3 y x4 en la pila    
    stp x14, x15, [sp, 16]     // Guarda x14 y x15 en la pila
    mov x27, #170            // contador de animacion
    animacionControl:
    bl animacionRectangle
    
    
    ldr x3, [sp, 8]  // Restaura x3 y 
    ldr x14, [sp, 16]  // Restaura x14 

    sub  x3 , x3 , 1
    add x14 , x14 ,1

    str x3, [sp, 8]     // Guarda x3 
    str x14, [sp, 16]     // Guarda x14 

    // Dibujar el primer barco
    mov x1, 30
    mov x2, 20
    mov x3, x3
    mov x4, 370
    bl ship1

    // Dibujar el segundo barco
    mov x1, 30
    mov x2, 20
    mov x3, x14
    mov x4, 370
    bl ship2 

    
    mov x22,#10000
    bl delay
    
    sub x27, x27, #1
    cbnz x27, animacionControl
    bl boomAnimacion
    bl delay2
    bl animacionRectangle
    bl animacionFuego
    
    // volver los valores de la pila a sus estado original 
    ldp x29, x30, [sp, 0]  // Restaura x29 y x30 desde la pila

    add sp, sp, 16         // Libera los 16 bytes reservados en la pila

    ret

animacionRectangle: 
//params: x1 = Width, x2 = Heigh, x3= initial x, x4 = initial y, x10 = color
    sub sp, sp, 16
    stp x29, x30, [sp, 8]  // Guarda x29 y x30 en la pila
    add x29, sp, 8         // Actualiza el marco de pila
    movz x10, 0x002D, lsl 16
    movk x10, 0x5D6D, lsl 0
    mov x1, 640
    mov x2, 170
    mov x3, 0
    mov x4, 320
    bl rectangle

    ldp x29, x30, [sp, 8]  // Restaura x29 y x30 desde la pila
    add sp, sp, 16         // Libera los 16 bytes reservados en la pila
    ret

delay: 
    mov x24, #1000       // Contador del bucle externo
delay_outer_loop:
    mov x25, #10000        // Contador del bucle interno
delay_inner_loop:
    sub x25, x25, 1
    cbnz x25, delay_inner_loop
    sub x24, x24, 1
    cbnz x24, delay_outer_loop
    ret

delay2: 
    mov x24, #10000       // Contador del bucle externo
delay_outer_loop2:
    mov x25, #10000        // Contador del bucle interno
delay_inner_loop2:
    sub x25, x25, 1
    cbnz x25, delay_inner_loop2
    sub x24, x24, 1
    cbnz x24, delay_outer_loop2
    ret

boomAnimacion: 

sub sp , sp , 16
stp x29 , x30 , [sp , 0]
add x29 , sp , 0
    mov x27 , 170
    boomAnimacionControl:

    /*blanco  */
    movz x10 , 0x00FF , lsl 16
    movk x10 , 0xFFFF , lsl 00
    /*primera nube blanco  */
    mov x1 , 40
    mov x2 , 5
    mov x3, 290
    mov x4, 390
    bl rectangle
    mov x1 , 35 
    mov x2 , 5
    mov x3, 300
    mov x4, 385
    bl rectangle
    mov x1 , 25
    mov x2 , 5
    mov x3, 310
    mov x4, 380
    bl rectangle
    mov x1 , 25
    mov x2 , 5
    mov x3, 300
    mov x4, 395
    bl rectangle
    /*fin primera nube blanco */

    /*segunda nube blanco */
    mov x1 , 15
    mov x2 , 20
    mov x3, 350
    mov x4, 380
    bl rectangle
    mov x1 , 10
    mov x2 ,20
    mov x3, 365
    mov x4, 375
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 350
    mov x4, 400
    bl rectangle
    /*fin segunda nube blanco */
    /*tercera nube blanco */
    mov x1 , 20
    mov x2 , 10
    mov x3, 270
    mov x4, 375
    bl rectangle
    mov x1 , 10
    mov x2 , 15
    mov x3, 280
    mov x4, 380
    bl rectangle
    mov x1 , 10
    mov x2 , 5
    mov x3, 270
    mov x4, 385
    bl rectangle
    /*fin tercera nube blanco */
    bl delay2

    
    /* Naranja  */
    movz x10 , 0x00FD , lsl 16
    movk x10 , 0x8D06 , lsl 00

    /*primera nube naranja*/
    mov x1 , 15
    mov x2 , 5
    mov x3, 325
    mov x4, 395
    bl rectangle
    mov x1 , 15
    mov x2 , 10
    mov x3, 330
    mov x4, 390
    bl rectangle
    mov x1 , 15
    mov x2 , 5
    mov x3, 335
    mov x4, 385
    bl rectangle
    mov x1 , 30
    mov x2 , 10
    mov x3, 310
    mov x4, 400
    bl rectangle
    mov x1 , 20
    mov x2 , 5
    mov x3, 320
    mov x4, 410
    bl rectangle
    mov x1 , 20
    mov x2 , 5
    mov x3, 290
    mov x4, 380
    bl rectangle
    mov x1 , 10
    mov x2 , 5
    mov x3, 290
    mov x4, 385
    bl rectangle
    mov x1 , 50
    mov x2 , 5
    mov x3, 285
    mov x4, 375
    bl rectangle
    mov x1 , 10
    mov x2 , 5
    mov x3, 290
    mov x4, 395
    bl rectangle
    mov x1 , 20
    mov x2 , 10
    mov x3, 290
    mov x4, 400
    bl rectangle
    mov x1 , 25
    mov x2 , 5
    mov x3, 330
    mov x4, 380
    bl rectangle
    /*fin primera nube naranja */

    /*segunda nube naranja */
    mov x1 , 30
    mov x2 , 5
    mov x3, 355
    mov x4, 400
    bl rectangle
    mov x1 , 15
    mov x2 , 5
    mov x3, 365
    mov x4, 395
    bl rectangle
    mov x1 , 40
    mov x2 , 5
    mov x3, 340
    mov x4, 405
    bl rectangle
    mov x1 , 40
    mov x2 , 5
    mov x3, 340
    mov x4, 410
    bl rectangle
    mov x1 , 10
    mov x2 , 40
    mov x3, 375
    mov x4, 375
    bl rectangle
    mov x1 , 20
    mov x2 , 10
    mov x3, 350
    mov x4, 370
    bl rectangle
    mov x1 , 30
    mov x2 , 5
    mov x3, 360
    mov x4, 370
    bl rectangle

    /*fin segunda nube naranja */

    /*tercera nube naranja */
    mov x1 , 40
    mov x2 , 5
    mov x3, 240
    mov x4, 390
    bl rectangle
    mov x1 , 15
    mov x2 , 5
    mov x3, 250
    mov x4, 380
    bl rectangle
    mov x1 , 30
    mov x2 , 5
    mov x3, 240
    mov x4, 385
    bl rectangle
    mov x1 , 20
    mov x2 , 5
    mov x3, 250
    mov x4, 375
    bl rectangle
    mov x1 , 40
    mov x2 , 5
    mov x3, 250
    mov x4, 370
    bl rectangle
    mov x1 , 50
    mov x2 , 15
    mov x3, 240
    mov x4, 395
    bl rectangle
    /*fin tercera nube naranja  */

    bl delay2

    /* Rojo  */
    movz x10 , 0x00FB , lsl 16
    movk x10 , 0x361F , lsl 00
    /*primera nube rojo */

    mov x1 , 5
    mov x2 , 35
    mov x3, 285
    mov x4, 380
    bl rectangle
    mov x1 , 32
    mov x2 , 5
    mov x3, 290
    mov x4, 410
    bl rectangle
    mov x1 , 5
    mov x2 , 15
    mov x3, 345
    mov x4, 390
    bl rectangle
    mov x1 , 5
    mov x2 , 20
    mov x3, 340
    mov x4, 400
    bl rectangle
    mov x1 , 5
    mov x2 , 20
    mov x3, 290
    mov x4, 380
    bl rectangle
    mov x1 , 60
    mov x2 , 5
    mov x3, 290
    mov x4, 370
    bl rectangle
    mov x1 , 20
    mov x2 , 5
    mov x3, 330
    mov x4, 375
    bl rectangle
    /*fin primera nube rojo */

    /*segunda nube rojo */
    mov x1 , 5
    mov x2 , 40
    mov x3, 385
    mov x4, 375
    bl rectangle
    mov x1 , 5
    mov x2 , 10
    mov x3, 380
    mov x4, 400
    bl rectangle
    mov x1 , 15
    mov x2 , 5
    mov x3, 370
    mov x4, 410
    bl rectangle
    mov x1 , 40
    mov x2 , 5
    mov x3, 350
    mov x4, 415
    bl rectangle
    mov x1 , 40
    mov x2 , 5
    mov x3, 350
    mov x4, 365
    bl rectangle    
    /* fin segunda nube rojo */

    /*tercera nube rojo */
    mov x1 , 5
    mov x2 , 20
    mov x3, 240
    mov x4, 390
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 250
    mov x4, 380
    bl rectangle
    mov x1 , 10
    mov x2 , 15
    mov x3, 240
    mov x4, 370
    bl rectangle
    mov x1 , 40
    mov x2 , 5
    mov x3, 240
    mov x4, 365
    bl rectangle
    mov x1 , 45
    mov x2 , 5
    mov x3, 240
    mov x4, 410
    bl rectangle
    mov x1 , 5
    mov x2 , 10
    mov x3, 280
    mov x4, 400
    bl rectangle
    /*fin tercera nube rojo */
    bl delay2
    bl delay2
    /* escombros  */
    /*naranja */
    movz x10 , 0x00FD , lsl 16
    movk x10 , 0x8D06 , lsl 00
    mov x1 , 5
    mov x2 , 5
    mov x3, 180
    mov x4, 320
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 185
    mov x4, 325
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 190
    mov x4, 330
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 195
    mov x4, 335
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 200
    mov x4, 340
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 205
    mov x4, 345
    bl rectangle

    mov x1 , 5
    mov x2 , 5
    mov x3, 330
    mov x4, 320
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 330
    mov x4, 325
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 330
    mov x4, 330
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 330
    mov x4, 335
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 330
    mov x4, 340
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 330
    mov x4, 345
    bl rectangle

    mov x1 , 5
    mov x2 , 5
    mov x3, 430
    mov x4, 320
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 425
    mov x4, 325
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 420
    mov x4, 330
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 415
    mov x4, 335
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 410
    mov x4, 340
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 405
    mov x4, 345
    bl rectangle

    mov x1 , 5
    mov x2 , 5
    mov x3, 200
    mov x4, 440
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 205
    mov x4, 435
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 210
    mov x4, 430
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 215
    mov x4, 425
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 220
    mov x4, 420
    bl rectangle

    mov x1 , 5
    mov x2 , 5
    mov x3, 330
    mov x4, 440
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 330
    mov x4, 435
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 330
    mov x4, 430
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 330
    mov x4, 425
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 330
    mov x4, 420
    bl rectangle

    mov x1 , 5
    mov x2 , 5
    mov x3, 430
    mov x4, 440
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 425
    mov x4, 435
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 420
    mov x4, 430
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 415
    mov x4, 425
    bl rectangle
    mov x1 , 5
    mov x2 , 5
    mov x3, 410
    mov x4, 420
    bl rectangle




ldp x29 , x30 , [sp , 0]
add sp , sp , 16
ret

animacionFuego:
    sub sp , sp , 16
    stp x29 , x30 , [sp , 0]
    add x29 , sp , 0
    mov x27 , 100
    fuegoControl:
    bl animacionRectangle
    //bl delay2
    bl fuego1
    bl delay2
    //bl delay2
    
    bl animacionRectangle
    
    bl fuego2
    bl delay2
    //bl delay2

    bl animacionRectangle

    bl fuego3
    bl delay2
    //bl delay2 
    
    sub x27 , x27 , 1
    cbnz x27 , fuegoControl
    ldp x29 , x30 , [sp , 0]
    add sp , sp , 16
    ret

