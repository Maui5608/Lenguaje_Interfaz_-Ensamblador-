;-------------------------
;DAVID EZEQUIEL CABALLERO GONZALEZ
;-------------------------
;LENGUAJE DE INTERFAZ
;------------------------- 
;PROFESOR: DR. ALEJANDRO SAGUNDO DUARTE 
;-------------------------
;ACTIVIDAD 3.2 EJERCICIOS
;-------------------------
;PROGRAMA 4. CADENA

STACK SEGMENT STACK
    DW 64 DUP(?)
STACK ENDS

DATA SEGMENT
    mensj1  db 13,10,"Ingresa una cadena (max 15 chars):",13,10,"> $"
    mensj2  db 13,10,"La cadena ingresada es:",13,10,"> $"
    mensj3  db 13,10,"Longitud: $"
    otra    db 13,10,"Deseas ingresar otra cadena? (S/N): $"
    salto   db 13,10,13,10,"$"
    cadena  db 16,0,15 DUP(0),'$'
DATA ENDS     

CODE SEGMENT
ASSUME DS:DATA, CS:CODE, SS:STACK

;--------------------------------
;MACRO PARA IMPRIMIR
print MACRO cad
    mov ah, 09h
    lea dx, cad
    int 21h
ENDM

;--------------------------------
;MACRO PARA LEER
leer MACRO buf
    mov ah, 0Ah
    lea dx, buf
    int 21h
ENDM

;--------------------------------
;MACRO PARA BAJAR UNA LINEA
nueva_linea MACRO
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
ENDM

;----------------------------------------------------
;PROCEDIMIENTO PARA IMPRIMIR LA CADENA
print_cad PROC
    push bx
    push cx
    push dx
    push si

    mov  cl, [bx+1]      ;CUANTOS CARACTERES SE LEYERON
    xor  ch, ch
    cmp  cx, 0
    je   pc_fin          ;SI NO HAY NADA, NO SE IMPRIME
    mov  si, 2           ;LOS DATOS EMPIEZAN EN OFFSET 2

pc_loop:
    mov  dl, [bx+si]     ;TOMAR EL CARACTER
    mov  ah, 02h
    int  21h             ;IMPRIMIRLO EN PANTALLA
    inc  si
    loop pc_loop

pc_fin:
    pop si
    pop dx
    pop cx
    pop bx
    ret
print_cad ENDP

;----------------------------------------------------
;PROCEDIMIENTO PARA OBTENER LA LONGITUD DE LA CADENA
get_len PROC
    xor  ax, ax
    mov  al, [bx+1]      ;EL BYTE 1 DEL BUFFER TIENE LA LONGITUD REAL
    ret
get_len ENDP

;----------------------------------------------------
;PROCEDIMIENTO PARA IMPRIMIR UN NUMERO
print_num PROC
    push ax
    push bx
    push cx
    push dx

    mov  bx, 10
    xor  cx, cx          ;AQUI SE CUENTAN LOS DIGITOS

pn_div:
    xor  dx, dx
    div  bx              ;AX=COCIENTE, DX=DIGITO
    push dx              ;APILAR EL DIGITO
    inc  cx
    cmp  ax, 0
    jne  pn_div

pn_print:
    pop  dx
    add  dl, '0'         ;CONVERTIR A ASCII
    mov  ah, 02h
    int  21h
    loop pn_print

    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_num ENDP

;----------------------------------------------------
;PROCEDIMIENTO PARA LIMPIAR EL BUFFER ANTES DE LEER
limpiar_buf PROC
    push bx
    push cx
    push si

    mov  byte ptr [bx+1], 0   ;LONGITUD = 0
    mov  cx, 15               ;LIMPIAR LOS 15 BYTES DE DATOS
    xor  si, si

lb_loop:
    mov  byte ptr [bx+2+si], 0
    inc  si
    loop lb_loop

    pop  si
    pop  cx
    pop  bx
    ret
limpiar_buf ENDP

;--------------------------------
;INICIO DEL PROGRAMA
inicio:
    mov ax, DATA
    mov ds, ax

ciclo:
    ;LIMPIAR EL BUFFER ANTES DE LEER PARA NO TENER BASURA
    lea  bx, cadena
    call limpiar_buf

    ;LEER LA CADENA
    print mensj1
    leer  cadena

    nueva_linea

    ;MOSTRAR LA CADENA DE VUELTA
    print mensj2
    lea  bx, cadena
    call print_cad

    ;MOSTRAR LA LONGITUD
    print mensj3
    lea  bx, cadena
    call get_len         ;AX = LONGITUD
    call print_num

    print salto

    ;PREGUNTAR SI SE QUIERE INGRESAR OTRA CADENA
    print otra
    mov  ah, 01h
    int  21h
    cmp  al, 'S'
    je   ciclo
    cmp  al, 's'
    je   ciclo

    mov ax, 4C00h
    int 21h

CODE ENDS
END inicio