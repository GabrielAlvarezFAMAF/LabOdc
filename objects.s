.equ SCREEN_WIDTH,   640 // ancho de la pantalla en pixeles eje x
.equ SCREEN_HEIGH,   480 // alto de la pantalla en pixeles eje y

.global windows
.global printWindows
.global ventanas
.global estrellas
.global luna
.global arboles
.global totalWindows
.global ship

windows: 
// parametros: x1 = Width, x2 = Heigh, x3 = initial x, x4 = initial y, x5 = ventanas por fila, x6 = filas de ventanas, x8 = separación x, x22 = separación y
    sub sp, sp, 32
    stp x29, x30, [sp, 16]  // Guarda x29 y x30 en la pila
    add x29, sp, 16         // Actualiza el marco de pila
    stp x1, x2, [sp, 0]     // Guarda x1 y x2 en la pila
    stp x3, x4, [sp, 8]     // Guarda x3 y x4 en la pila
row_loop:
    mov x7, x5     // Inicializa el contador de ventanas por fila

window_loop:
    sub sp, sp, 16
    stur x3, [sp, 0] // Guarda x3 en la pila
    stur x4, [sp, 8] // Guarda x4 en la pila

    movz x10, 0xFFFF, lsl 16 // Color blanco
    movk x10, 0xFFFF, lsl 0
    bl rectangle   // Dibuja la ventana

    ldr x3, [sp, 0] // Restaura x3 desde la pila
    ldr x4, [sp, 8] // Restaura x4 desde la pila
    add sp, sp, 16

    add x3, x3, x1 // Mueve la coordenada x para la siguiente ventana (ancho de la ventana)
    add x3, x3, x8 // Añade la separación entre ventanas en el eje x
    sub x7, x7, 1  // Decrementa el contador de ventanas
    cbnz x7, window_loop // Si no hemos terminado, repite el bucle

    // Mueve la coordenada y para la siguiente fila de ventanas
    ldr x3, [sp, 8] // Restaura la coordenada x inicial
    add x4, x4, x2 // Mueve la coordenada y para la siguiente fila (alto de la ventana)
    add x4, x4, x22 // Añade la separación entre filas en el eje y
    stur x4, [sp, 16] // Guarda la nueva coordenada y en la pila
    sub x6, x6, 1  // Decrementa el contador de filas
    cbnz x6, row_loop // Si no hemos terminado, repite el bucle
    
    ldr x3, [sp, 8] // Restaura la coordenada x inicial
    ldr x4, [sp, 8] // Restaura la coordenada y inicial
    ldp x1, x2, [sp, 0]  // Restaura x1 y x2 desde la pila
    ldp x3, x4, [sp, 8] // Restaura x3 y x4 desde la pila
    ldp x29, x30, [sp, 16] // Restaura x29 y x30 desde la pila
    
    add sp, sp, 32

    ret


estrellas: 
    sub sp, sp, 16
    stp x29, x30, [sp, 8]
    add x29, sp, 8

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

    ldp x29, x30, [sp, 8]
    add sp, sp, 16
    ret

luna: 
    sub sp, sp, 16
    stp x29, x30, [sp, 8]
    add x29, sp, 8
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

    ldp x29, x30, [sp, 8]
    add sp, sp, 16
    ret 

arboles : 
    movz x10, 0x0014, lsl 16
    movk x10, 0x2204, lsl 00
    mov x1, 10
    mov x2, 20
    mov x3, 50
    mov x4, 270
    bl rectangle
    ret 

ship: 
    //params  x1 = width, x2 = heigh, x3 = initial x, x4 = initial y
    sub sp, sp, 16
    stp x29, x30, [sp, 8]
    add x29, sp, 8

    movz x10, 0x0000, lsl 16
    movk x10, 0x0000, lsl 00
    mov x1, 200
    mov x2, 50
    bl rectangle
    ldp x29, x30, [sp, 8]
    add sp, sp, 16
    ret 
    