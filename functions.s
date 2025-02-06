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


    movz x10 , 0xFFFF , lsl 16
    movk x10 , 0xFFFF , lsl 00
    /*primera fila primer edificio */
    mov x1, 7
    mov x2, 10
    mov x3, 242
    mov x4, 130 
    bl rectangle

    mov x4, 130 
    add x3 , x3 , 7
    bl rectangle

    mov x4, 130
    add x3 , x3 , 7
    bl rectangle

    mov x4, 130
    add x3 , x3 , 7
    bl rectangle

    /*segunda fila primer edificio */
    mov x3,242
    mov x4, 150
    bl rectangle

    mov x4, 150
    add x3 , x3 , 7
    bl rectangle

    mov x4, 150
    add x3 , x3 , 7
    bl rectangle

    mov x4, 150
    add x3 , x3 , 7
    bl rectangle

    /*tercera fila primer edificio */
    mov x3,242
    mov x4, 170
    bl rectangle

    mov x4, 170
    add x3 , x3 , 7
    bl rectangle

    mov x4, 170
    add x3 , x3 , 7
    bl rectangle

    mov x4, 170
    add x3 , x3 , 7
    bl rectangle

    /*cuarta fila primer edificio */
    mov x3,242
    mov x4, 190
    bl rectangle

    mov x4, 190
    add x3 , x3 , 7
    bl rectangle

    mov x4, 190
    add x3 , x3 , 7
    bl rectangle
    
    mov x4, 190
    add x3 , x3 , 7
    bl rectangle

    /*quinta fila primer edificio */
    mov x3,242
    mov x4, 210
    bl rectangle

    mov x4, 210
    add x3 , x3 , 7
    bl rectangle

    mov x4, 210
    add x3 , x3 , 7
    bl rectangle

    mov x4, 210
    add x3 , x3 , 7
    bl rectangle

    /*sexta fila primer edificio */
    mov x3,242
    mov x4, 230
    bl rectangle

    mov x4, 230
    add x3 , x3 , 7
    bl rectangle
    
    mov x4, 230
    add x3 , x3 , 7
    bl rectangle

    mov x4, 230
    add x3 , x3 , 7
    bl rectangle

    /*septima fila primer edificio */
    mov x3,242
    mov x4, 250
    bl rectangle
    
    mov x4, 250
    add x3 , x3 , 7
    bl rectangle
    
    mov x4, 250
    add x3 , x3 , 7
    bl rectangle

    mov x4, 250
    add x3 , x3 , 7
    bl rectangle

    /*segundo edificio primera fila*/
    mov x1, 7
    mov x2, 10
    mov x3, 350
    mov x4, 170
    bl rectangle

    mov x4, 170
    add x3 , x3 , 7
    bl rectangle

    mov x4, 170
    add x3 , x3 , 7
    bl rectangle

    mov x4, 170
    add x3 , x3 , 7
    bl rectangle

    /*segundo edificio segunda fila*/
    mov x3,350
    mov x4, 190
    bl rectangle

    mov x4, 190
    add x3 , x3 , 7
    bl rectangle

    mov x4, 190
    add x3 , x3 , 7
    bl rectangle

    mov x4, 190
    add x3 , x3 , 7
    bl rectangle

    /*segundo edificio tercera fila*/
    mov x3,350
    mov x4, 210
    bl rectangle
    
    mov x4, 210
    add x3 , x3 , 7
    bl rectangle

    mov x4, 210
    add x3 , x3 , 7
    bl rectangle

    mov x4, 210
    add x3 , x3 , 7
    bl rectangle

    /*segundo edificio cuarta fila*/
    mov x3,350
    mov x4, 230
    bl rectangle

    mov x4, 230
    add x3 , x3 , 7
    bl rectangle

    mov x4, 230
    add x3 , x3 , 7
    bl rectangle
    
    mov x4, 230
    add x3 , x3 , 7
    bl rectangle

    /*segundo edificio quinta fila*/
    mov x3,350
    mov x4, 250
    bl rectangle

    mov x4, 250
    add x3 , x3 , 7
    bl rectangle

    mov x4, 250
    add x3 , x3 , 7
    bl rectangle

    mov x4, 250
    add x3 , x3 , 7
    bl rectangle


    /*tercer edificio primera fila */
    mov x1, 7
    mov x2, 10
    mov x3, 440
    mov x4, 150
    bl rectangle

    mov x4, 150
    add x3 , x3 , 7
    bl rectangle

    mov x4, 150
    add x3 , x3 , 7
    bl rectangle

    mov x4, 150
    add x3 , x3 , 7
    bl rectangle

    /*tercer edificio segunda fila */
    mov x3,440
    mov x4, 170
    bl rectangle

    mov x4, 170
    add x3 , x3 , 7
    bl rectangle

    mov x4, 170
    add x3 , x3 , 7
    bl rectangle

    mov x4, 170
    add x3 , x3 , 7
    bl rectangle

    /*tercer edificio tercera fila */
    mov x3,440
    mov x4, 190
    bl rectangle

    mov x4, 190
    add x3 , x3 , 7
    bl rectangle

    mov x4, 190
    add x3 , x3 , 7
    bl rectangle

    mov x4, 190
    add x3 , x3 , 7
    bl rectangle

    /*tercer edificio cuarta fila */
    mov x3,440
    mov x4, 210
    bl rectangle

    mov x4, 210
    add x3 , x3 , 7
    bl rectangle

    mov x4, 210
    add x3 , x3 , 7
    bl rectangle

    mov x4, 210
    add x3 , x3 , 7
    bl rectangle

    /*tercer edificio quinta fila */
    mov x3,440
    mov x4, 230
    bl rectangle

    mov x4, 230
    add x3 , x3 , 7
    bl rectangle

    mov x4, 230
    add x3 , x3 , 7
    bl rectangle

    mov x4, 230
    add x3 , x3 , 7
    bl rectangle

    /*tercer edificio sexta fila */
    mov x3,440
    mov x4, 250
    bl rectangle

    mov x4, 250
    add x3 , x3 , 7
    bl rectangle

    mov x4, 250
    add x3 , x3 , 7
    bl rectangle

    mov x4, 250
    add x3 , x3 , 7
    bl rectangle

    /*cuarto edificio primera fila */
    mov x1, 5
    mov x2, 8
    mov x3, 580
    mov x4, 170
    bl rectangle

    mov x4, 170
    add x3 , x3 , 5
    bl rectangle

    mov x4, 170
    add x3 , x3 , 5
    bl rectangle

    /*cuarto edifcio segunda fila */
    mov x3,580
    mov x4, 182
    bl rectangle

    mov x4, 182
    add x3 , x3 , 5
    bl rectangle

    mov x4, 182
    add x3 , x3 , 5
    bl rectangle

    /*cuarto edificio tercera fila */
    mov x3,580
    mov x4, 194
    bl rectangle

    mov x4, 194
    add x3 , x3 , 5
    bl rectangle

    mov x4, 194
    add x3 , x3 , 5
    bl rectangle

    /*cuarto edificio cuarta fila */
    mov x3,580
    mov x4, 206
    bl rectangle

    mov x4, 206
    add x3 , x3 , 5
    bl rectangle

    mov x4, 206
    add x3 , x3 , 5
    bl rectangle

    /*cuarto edificio quinta fila */
    mov x3,580
    mov x4, 218
    bl rectangle
    
    mov x4, 218
    add x3 , x3 , 5
    bl rectangle

    mov x4, 218
    add x3 , x3 , 5
    bl rectangle

    /*cuarto edificio sexta fila */
    mov x3,580
    mov x4, 230
    bl rectangle

    mov x4, 230
    add x3 , x3 , 5
    bl rectangle

    mov x4, 230
    add x3 , x3 , 5
    bl rectangle

    /*cuarto edificio septima fila */
    mov x3,580
    mov x4, 242
    bl rectangle

    mov x4, 242
    add x3 , x3 , 5
    bl rectangle
    
    mov x4, 242
    add x3 , x3 , 5
    bl rectangle

    /*cuarto edificio octava fila */
    mov x3,580
    mov x4, 254
    bl rectangle

    mov x4, 254
    add x3 , x3 , 5
    bl rectangle

    mov x4, 254
    add x3 , x3 , 5
    bl rectangle

    /*quinto edificio primera fila */
    mov x1, 7
    mov x2, 10
    mov x3, 140
    mov x4, 165
    bl rectangle

    mov x4, 165
    add x3 , x3 , 7
    bl rectangle

    mov x4, 165
    add x3 , x3 , 7
    bl rectangle

    mov x4, 165
    add x3 , x3 , 7
    bl rectangle


    /*quinto edificio segunda fila */
    mov x3,140
    mov x4, 185
    bl rectangle

    mov x4, 185
    add x3 , x3 , 7
    bl rectangle

    mov x4, 185
    add x3 , x3 , 7
    bl rectangle

    mov x4, 185
    add x3 , x3 , 7
    bl rectangle

    /*quinto edificio tercera fila */
    mov x3,140
    mov x4, 205
    bl rectangle

    mov x4, 205
    add x3 , x3 , 7
    bl rectangle

    mov x4, 205
    add x3 , x3 , 7
    bl rectangle

    mov x4, 205
    add x3 , x3 , 7
    bl rectangle

    /*quinto edificio cuarta fila */
    mov x3,140
    mov x4, 225
    bl rectangle

    mov x4, 225
    add x3 , x3 , 7
    bl rectangle

    mov x4, 225
    add x3 , x3 , 7
    bl rectangle

    mov x4, 225
    add x3 , x3 , 7
    bl rectangle

    /*quinto edificio quinta fila */
    mov x3,140
    mov x4, 245
    bl rectangle

    mov x4, 245
    add x3 , x3 , 7
    bl rectangle
    
    mov x4, 245
    add x3 , x3 , 7
    bl rectangle

    mov x4, 245
    add x3 , x3 , 7
    bl rectangle

    /* espeacio entre edifcios */
    movz x10, 0x0003, lsl 16
    movk x10, 0x1723, lsl 00
    
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
    /*estrellas */ 
    movz x10, 0xFFFF, lsl 16
    movk x10, 0xFFFF, lsl 00
    mov x1, 3
    mov x2, 3
    mov x3, 10
    mov x4, 20 
    bl rectangle
    
    mov x3, 40
    mov x4, 50
    bl rectangle

    mov x3, 60
    mov x4, 70
    bl rectangle

    mov x3, 100
    mov x4, 20
    bl rectangle

    mov x3, 110
    mov x4, 50
    bl rectangle

    mov x3, 130
    mov x4, 70
    bl rectangle

    mov x3, 170
    mov x4, 20
    bl rectangle

    mov x3, 180
    mov x4, 50
    bl rectangle

    mov x3, 260 
    mov x4, 70
    bl rectangle

    mov x3, 400
    mov x4, 20
    bl rectangle

    mov x3, 410
    mov x4, 20
    bl rectangle

    mov x3, 420
    mov x4, 20
    bl rectangle

    mov x3, 490
    mov x4, 60
    bl rectangle

    mov x3, 500
    mov x4, 90
    bl rectangle

    mov x3, 560 
    mov x4, 70
    bl rectangle

    mov x3, 580
    mov x4, 20
    bl rectangle

    mov x3, 590
    mov x4, 50
    bl rectangle

    mov x3, 610
    mov x4, 70
    bl rectangle

    mov x3, 620
    mov x4, 20
    bl rectangle

    /*luna  */
    movz x10, 0x00F8, lsl 16
    movk x10, 0xF7C3, lsl 00
    mov x1, 20
    mov x2, 3
    mov x3, 285
    mov x4, 20
    bl rectangle
    mov x1, 30 
    mov x2, 3
    mov x3, 280
    mov x4, 23
    bl rectangle
    mov x1, 40
    mov x2, 15
    mov x3, 275
    mov x4, 26
    bl rectangle
    mov x1, 30
    mov x2, 3
    mov x3, 280
    mov x4, 41
    bl rectangle
    mov x1, 20
    mov x2, 3
    mov x3, 285
    mov x4, 44
    bl rectangle

    /* arbustos */ 
    movz x10, 0x0014, lsl 16
    movk x10, 0x2204, lsl 00
    mov x1, 30
    mov x2, 10
    mov x3, 0
    mov x4, 270
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







