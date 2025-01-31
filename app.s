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
mov x1, 120
mov x2, 10
mov x3, 50
mov x4, 50
movz x10, 0x0000, lsl 16
movk x10, 0x0000, lsl 00
/* Configuracion y color de las ventanas  */

movz x10 , 0xFFFF , lsl 16 
movk x10 , 0xFFFF , lsl 00
mov x1, 7      // Ancho de la ventana
mov x2, 10     // Alto de la ventana
mov x3, 242    // Coordenada x inicial
mov x4, 130    // Coordenada y inicial
mov x5, 4      // Número de ventanas por fila
mov x6, 7      // Número de filas de ventanas

mov x8, 7    // Separación entre ventanas en el eje x
mov x22, 10     // Separación entre filas en el eje y

bl windows


InfLoop:
	b InfLoop

