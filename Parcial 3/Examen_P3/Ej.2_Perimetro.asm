;-------------------------
;DAVID EZEQUIEL CABALLERO GONZALEZ
;-------------------------
;LENGUAJE DE INTERFAZ
;------------------------- 
;PROFESOR: DR. ALEJANDRO SAGUNDO DUARTE 
;-------------------------
;EXAMEN U3
;-------------------------  
;EJERCICIO 2. SERIE B. PERIMETRO DEL ROMBOIDE


STACK SEGMENT STACK
    DW 64 DUP(?)
STACK ENDS

DATA SEGMENT
    msg_base    db 13,10,"Base (max 3 dig): $"
    msg_lado    db 13,10,"Lado (max 3 dig): $"
    result      db 13,10,"Perimetro del romboide: $"
    salto       db 13,10,"$"
    otra        db 13,10,"Otra operacion? (S/N): $"

    ;AQUI DEFINI EL TAMANIO DE LOS BUFFER PARA LOS NUMEROS (3 DIGITOS MAX)
    buf1    db 4,0,3 DUP(0),'$'
    buf2    db 4,0,3 DUP(0),'$'
DATA ENDS

CODE SEGMENT
ASSUME DS:DATA, CS:CODE, SS:STACK

;---------------------------------
;MACRO: IMPRIMIR CADENA
print MACRO cadena
    mov ah, 09h
    lea dx, cadena
    int 21h
ENDM

;---------------------------------
;MACRO: LEER CADENA CON BUFFER DOS
leer MACRO buffer
    mov ah, 0Ah
    lea dx, buffer
    int 21h
ENDM

;---------------------------------
;PROCEDIMIENTO PARA CONVERTIR ASCII A NUMERO
convertir PROC
    push bx
    push cx
    push dx
    push si

    xor  ax, ax          ;AX = 0, AQUI SE VA ACUMULANDO EL NUMERO
    xor  si, si          ;SI = INDICE DEL CARACTER ACTUAL
    mov  cl, [bx+1]      ;CL = CUANTOS CARACTERES SE LEYERON
    xor  ch, ch
    cmp  cx, 0
    je   conv_fin

conv_loop:
    push cx
    mov  cx, 10
    mul  cx              ;AX = AX*10, SE DESPLAZA EL NUMERO UN LUGAR
    pop  cx
    xor  dx, dx
    mov  dl, [bx+2+si]
    sub  dl, '0'         ;CONVERTIR DE ASCII A NUMERO
    add  ax, dx
    inc  si
    loop conv_loop

conv_fin:
    pop si
    pop dx
    pop cx
    pop bx
    ret
convertir ENDP

;---------------------------------
;PROCEDIMIENTO PARA IMPRIMIR UN NUMERO EN PANTALLA
print_num PROC
    push ax
    push bx
    push cx
    push dx

    mov  bx, 10
    xor  cx, cx          ;AQUI SE CUENTAN LOS DIGITOS

pn_div:
    xor  dx, dx
    div  bx              ;AX=COCIENTE, DX=DIGITO ACTUAL
    push dx              ;SE APILA EL DIGITO
    inc  cx
    cmp  ax, 0
    jne  pn_div

pn_print:
    pop  dx
    add  dl, '0'         ;CONVERTIR DE NUMERO A ASCII
    mov  ah, 02h
    int  21h
    loop pn_print

    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_num ENDP

;---------------------------------
;PROCEDIMIENTO PARA CALCULAR EL PERIMETRO DEL ROMBOIDE 
;(ESTE PROCEDIMIENTO LO HICE EN BASE A UNO QUE TENIA DE SUMA,
;AGREGANDO UNA MULTIPLICACION A LA SUMA DE LA BASE Y EL LADO) 
calc_romboide PROC
    mov  ax, si
    add  ax, di          ;AX = BASE + LADO
    mov  bx, 2
    mul  bx              ;AX = 2 * (BASE + LADO)

    push ax              ;GUARDAR ANTES DEL PRINT PORQUE INT 21h MODIFICA AX
    print result
    pop  ax
    call print_num
    print salto
    ret
calc_romboide ENDP


;INICIO DEL PROGRAMA
inicio:
    mov ax, DATA
    mov ds, ax

ciclo:
    ;LEER BASE Y GUARDAR EN SI
    print msg_base
    leer  buf1
    lea   bx, buf1
    call  convertir
    mov   si, ax         ;SI = BASE

    ;LEER LADO Y GUARDAR EN DI
    print msg_lado
    leer  buf2
    lea   bx, buf2
    call  convertir
    mov   di, ax         ;DI = LADO

    call calc_romboide

    print otra
    mov  ah, 01h
    int  21h
    cmp  al, 'S'
    je   ciclo
    cmp  al, 's'
    je   ciclo

    mov  ax, 4C00h
    int  21h

CODE ENDS
END inicio