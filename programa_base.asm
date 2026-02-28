# Estructura de Computadores - Laboratorio 1
# Programa base: calcula Y[i] = A * X[i] + B para un vector de 8 elementos
# Version sin optimizar, con los riesgos de datos presentes tal como quedan
# al escribir el codigo de forma directa.
#
# Autor: flower Cordoba
# Fecha: 27/02/2026

.data
    vector_x: .word 1, 2, 3, 4, 5, 6, 7, 8   # datos de entrada
    vector_y: .space 32                         # resultados (8 palabras * 4 bytes)
    const_a:  .word 3                           # A = 3
    const_b:  .word 5                           # B = 5
    tamano:   .word 8                           # cantidad de elementos

.text
.globl main

main:
    la $s0, vector_x      # direccion base de X
    la $s1, vector_y      # direccion base de Y
    lw $t0, const_a       # A en $t0
    lw $t1, const_b       # B en $t1
    lw $t2, tamano        # n en $t2
    li $t3, 0             # i = 0

loop:
    beq $t3, $t2, fin     # si i == n, terminar

    sll $t4, $t3, 2       # desplazamiento = i * 4
    addu $t5, $s0, $t4    # direccion de X[i]

    # Load-Use Hazard: lw escribe $t6 en WB, mul lo necesita en EX.
    # El hardware inserta 1 stall aqui porque el dato no llego a tiempo.
    lw $t6, 0($t5)        # $t6 = X[i]
    mul $t7, $t6, $t0     # $t7 = X[i] * A  -- depende del lw anterior

    # RAW Hazard: addu necesita $t7 que acaba de escribir mul.
    addu $t8, $t7, $t1    # $t8 = Y[i] = A*X[i] + B  -- depende de mul

    addu $t9, $s1, $t4    # direccion de Y[i]
    sw $t8, 0($t9)        # guardar resultado

    addi $t3, $t3, 1      # i++
    j loop

fin:
    li $v0, 10
    syscall
