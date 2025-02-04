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
.global brick
.global bricklane


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

    /*texturas del primer color  */
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
    movz x10,0x0007, lsl 16
    movk x10,0x576F, lsl 00
    b rectangleDegradeLoop







