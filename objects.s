.equ SCREEN_WIDTH,   640 // ancho de la pantalla en pixeles eje x
.equ SCREEN_HEIGH,   480 // alto de la pantalla en pixeles eje y

.global structure

structure: 
    windows: 
    /*ventanas de dos colores blanco y amarillo 
        color 1 blanco  */ 
    movz x10 , 0xFFFF , lsl 16 
    movk x10 , 0xFFFF , lsl 00
    mov x1, 7      // Ancho de la ventana
    mov x2, 10     // Alto de la ventana
    mov x3, 242    // Coordenada x inicial
    mov x4, 130    // Coordenada y inicial
    mov x5, 4      // Número de ventanas por fila
    mov x6, 8      // Número de filas de ventanas

row_loop:
    mov x7, x5     // Inicializa el contador de ventanas por fila

window_loop:
    sub sp, sp, 16
    stur x3, [sp, 0] // Guarda x3 en la pila
    stur x4, [sp, 8] // Guarda x4 en la pila

    bl rectangle   // Dibuja la ventana

    ldr x3, [sp, 0] // Restaura x3 desde la pila
    ldr x4, [sp, 8] // Restaura x4 desde la pila
    add sp, sp, 16

    add x3, x3, 14 // Mueve la coordenada x para la siguiente ventana (7 píxeles de ancho + 2 píxeles de separación)
    sub x7, x7, 1  // Decrementa el contador de ventanas
    cbnz x7, window_loop // Si no hemos terminado, repite el bucle

    // Mueve la coordenada y para la siguiente fila de ventanas
    add x4, x4, 20 // Mueve la coordenada y para la siguiente fila (10 píxeles de alto + 20 píxeles de separación)
    mov x3, 242    // Restaura la coordenada x inicial
    sub x6, x6, 1  // Decrementa el contador de filas
    cbnz x6, row_loop // Si no hemos terminado, repite el bucle

    ret




