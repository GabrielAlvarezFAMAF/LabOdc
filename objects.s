.equ SCREEN_WIDTH,   640 // ancho de la pantalla en pixeles eje x
.equ SCREEN_HEIGH,   480 // alto de la pantalla en pixeles eje y

.global windows

windows: 
// parametros: x1 = Width, x2 = Heigh, x3 = initial x, x4 = initial y, x5 = ventanas por fila, x6 = filas de ventanas, x8 = separación x, x9 = separación y

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

    add x3, x3, x1 // Mueve la coordenada x para la siguiente ventana (ancho de la ventana)
    add x3, x3, x8 // Añade la separación entre ventanas en el eje x
    sub x7, x7, 1  // Decrementa el contador de ventanas
    cbnz x7, window_loop // Si no hemos terminado, repite el bucle

    // Mueve la coordenada y para la siguiente fila de ventanas
    add x4, x4, x2 // Mueve la coordenada y para la siguiente fila (alto de la ventana)
    add x4, x4, x22 // Añade la separación entre filas en el eje y
    mov x3, 242    // Restaura la coordenada x inicial
    sub x6, x6, 1  // Decrementa el contador de filas
    cbnz x6, row_loop // Si no hemos terminado, repite el bucle

    ret




