# Estructura de Computadores - Laboratorio 1
# Programa optimizado: misma logica que el base pero con instrucciones reordenadas
# para eliminar el stall del Load-Use Hazard entre lw y mul.
#
# La idea es simple: addu $t9 no depende de $t6, asi que se puede mover
# justo despues del lw. De esa forma cuando mul necesita $t6, ya paso
# un ciclo y el dato esta disponible. Sin stall.
#
# Autor: colgii26
# Fecha: 27/02/2026

.data
    vector_x: .word 1, 2, 3, 4, 5, 6, 7, 8
    vector_y: .space 32
    const_a:  .word 3
    const_b:  .word 5
    tamano:   .word 8

.text
.globl main

main:
    la $s0, vector_x
    la $s1, vector_y
    lw $t0, const_a
    lw $t1, const_b
    lw $t2, tamano
    li $t3, 0             # i = 0

loop:
    beq $t3, $t2, fin

    sll $t4, $t3, 2       # desplazamiento = i * 4
    addu $t5, $s0, $t4    # direccion de X[i]

    lw $t6, 0($t5)        # $t6 = X[i]
    addu $t9, $s1, $t4    # direccion de Y[i] -- movida aqui, cubre el stall del lw

    mul $t7, $t6, $t0     # $t7 = X[i] * A  -- $t6 ya llego, sin stall
    addu $t8, $t7, $t1    # $t8 = Y[i]
    sw $t8, 0($t9)        # guardar resultado

    addi $t3, $t3, 1      # i++
    j loop

fin:
    li $v0, 10
    syscall
