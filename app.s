.equ SCREEN_WIDTH,   640 // ancho de la pantalla en pixeles eje x
.equ SCREEN_HEIGH,   480 // alto de la pantalla en pixeles eje y
.equ BITS_PER_PIXEL, 32

.equ GPIO_BASE,    0x3f200000
.equ GPIO_GPFSEL0, 0x00
.equ GPIO_GPLEV0,  0x34

.globl main

main:
    // x0 contiene la direccion base del framebuffer
    mov x20, x0 // Guarda la dirección base del framebuffer en x20
    //---------------- CODE HERE ------------------------------------

    //movz x10, 0x002B, lsl 16
    //movk x10, 0x80A2, lsl 00

    movz x10, 0x0003, lsl 16
    movk x10, 0x1723, lsl 00
    
    bl background
    
    bl estrellas
    bl luna

    movz x10 , 0xFFFF , lsl 16 
    movk x10 , 0xFFFF , lsl 00
    mov x1, 7      // Ancho de la ventana
    mov x2, 10     // Alto de la ventana
    mov x3, 140    // Coordenada x inicial
    mov x4, 160    // Coordenada y inicial
    mov x5, 4      // Número de ventanas por fila
    mov x6, 6      // Número de filas de ventanas
    mov x8, 7      // Separación entre ventanas en el eje x
    mov x22, 10    // Separación entre filas en el eje y
    bl windows

    movz x10 , 0xFFFF , lsl 16 
    movk x10 , 0x00FF , lsl 00
    mov x1, 7      // Ancho de la ventana
    mov x2, 10     // Alto de la ventana
    mov x3, 240    // Coordenada x inicial
    mov x4, 120   // Coordenada y inicial
    mov x5, 4      // Número de ventanas por fila
    mov x6, 8      // Número de filas de ventanas
    mov x8, 7      // Separación entre ventanas en el eje x
    mov x22, 10    // Separación entre filas en el eje y
    bl windows

    movz x10 , 0xFFFF , lsl 16 
    movk x10 , 0x00FF , lsl 00
    mov x1, 7      // Ancho de la ventana
    mov x2, 10     // Alto de la ventana
    mov x3, 350    // Coordenada x inicial
    mov x4, 160   // Coordenada y inicial
    mov x5, 4      // Número de ventanas por fila
    mov x6, 6     // Número de filas de ventanas
    mov x8, 7      // Separación entre ventanas en el eje x
    mov x22, 10    // Separación entre filas en el eje y
    bl windows

    movz x10 , 0xFFFF , lsl 16 
    movk x10 , 0x00FF , lsl 00
    mov x1, 7      // Ancho de la ventana
    mov x2, 10     // Alto de la ventana
    mov x3, 440    // Coordenada x inicial
    mov x4, 140  // Coordenada y inicial
    mov x5, 4      // Número de ventanas por fila
    mov x6, 7      // Número de filas de ventanas
    mov x8, 7      // Separación entre ventanas en el eje x
    mov x22, 10    // Separación entre filas en el eje y
    bl windows

    movz x10 , 0xFFFF , lsl 16 
    movk x10 , 0x00FF , lsl 00
    mov x1, 5      // Ancho de la ventana
    mov x2, 7     // Alto de la ventana
    mov x3, 575   // Coordenada x inicial
    mov x4, 170   // Coordenada y inicial
    mov x5, 3      // Número de ventanas por fila
    mov x6, 6      // Número de filas de ventanas
    mov x8, 10      // Separación entre ventanas en el eje x
    mov x22,10    // Separación entre filas en el eje y
    bl windows


    // comienzo el bucle de animacion 
    mov x1, 30 
    mov x2 , 20 
    mov x3, 500
    mov x4, 370
    mov x14 ,100
    mov x15 , 370
    bl animacionloop
    bl rectangle
    //bl arboles
    //bl boom 
InfLoop:
    b InfLoop

