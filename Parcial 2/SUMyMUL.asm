;ACTIVIDAD 2.2. EJERCICIOS
;-------------------------
;DAVID EZEQUIEL CABALLERO GONZALEZ
;-------------------------
;LENGUAJE DE INTERFAZ
;-------------------------
;CREACION DE UN CODIGO QUE PERMITA LEER 2 NUMEROS Y 
;HACER LA SUMA Y MULTIPLICACION DE ESOS NUMEROS
;MODIFICANDO EL CODIGO DE COMPARAR.asm 
;-------------------------
;CODIGOS UTILIZADOS
;COMPARAR.asm: CODIGO BASE PARA LA LECTURA DE 2 NUMEROS



STACK SEGMENT STACK
DW 64 DUP(?)
STACK ENDS

DATA SEGMENT
txt1 db 'Solo se permiten numeros$'
suma db 'El resultado de la suma es: $'
mult db 'El resultado de la multiplicacion es: $'
DATA ENDS

CODE SEGMENT
ASSUME DS:DATA, CS:CODE, SS:STACK

Inicio:
    MOV AX, DATA
    MOV DS, AX

    mov ah, 01
    int 21h
    mov bl, al

    mov ah, 01
    int 21h
    mov cl, al

    cmp bl, cl
    ja mayor
    jb menor
    je igual

mayor:
    mov ah, 09
    mov dx, offset mayor1
    int 21h
    jmp salir

menor:
    mov ah, 09
    mov dx, offset menor1
    int 21h
    jmp salir

igual:
    mov ah, 09
    mov dx, offset igual1
    int 21h
    jmp salir

salir:
    mov ah, 4ch
    int 21h

CODE ENDS
END Inicio