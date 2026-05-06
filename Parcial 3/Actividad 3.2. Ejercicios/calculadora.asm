;-------------------------
;DAVID EZEQUIEL CABALLERO GONZALEZ
;-------------------------
;LENGUAJE DE INTERFAZ
;------------------------- 
;PROFESOR: DR. ALEJANDRO SAGUNDO DUARTE 
;-------------------------
;ACTIVIDAD 3.2 EJERCICIOS
;-------------------------
;PROGRAMA 2. CALCULADORA BASICA

STACK SEGMENT STACK
    DW 64 DUP(?)
STACK ENDS

DATA SEGMENT
    mensj1  db 13,10,"Primer numero  (max 3 dig): $"
    mensj2  db 13,10,"Segundo numero (max 3 dig): $" 
    
    opciones    db 13,10,"Selecciona una operacion:",13,10
            db "  1) Suma",13,10
            db "  2) Resta",13,10
            db "  3) Multiplicacion",13,10
            db "  4) Division",13,10
            db "Opcion: $"    
            
    result  db 13,10,"Resultado: $"
    err_op  db 13,10,"Opcion no valida, intenta de nuevo",13,10, "Opcion: $"
    err_div db 13,10,"Error: no se puede dividir entre cero$"
    negativo db "-$"          ;PARA MOSTRAR EL SIGNO CUANDO LA RESTA ES NEGATIVA
    salto   db 13,10,"$"
    otra    db 13,10,"Otra operacion? (S/N): $"

    ;LOS NUMEROS SON MAX 3 DIGITOS (999), TONS CON 4 BYTES SOBRA
    n1  db 4,0,3 DUP(0),'$'
    n2  db 4,0,3 DUP(0),'$'
DATA ENDS

CODE SEGMENT
ASSUME DS:DATA, CS:CODE, SS:STACK

;--------------------------------
;MACRO PARA IMPRIMIR
print MACRO cadena
    mov ah, 09h
    lea dx, cadena
    int 21h
ENDM

;--------------------------------
;MACRO PARA LEER
leer MACRO buffer
    mov ah, 0Ah
    lea dx, buffer
    int 21h
ENDM

;----------------------------------------------------
;PROCEDIMIENTO PARA CONVERTIR ASCII A NUMERO
convertir PROC
    push bx
    push cx
    push dx
    push si

    xor  ax, ax          ;AX = 0, AQUI SE VA ACUMULANDO EL NUMERO
    xor  si, si          ;SI = 0, ES EL INDICE DEL CARACTER ACTUAL
    mov  cl, [bx+1]      ;CL = CUANTOS CARACTERES SE LEYERON
    xor  ch, ch
    cmp  cx, 0
    je   conv_fin

conv_loop:
    push cx
    mov  cx, 10
    mul  cx              ;AQUI SE MULTIPLICA LO ACUMULADO POR 10 Y SE SUMA EL NUEVO DIGITO
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

;---------------------------------------------
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
    div  bx              ;AX=COCIENTE, DX=DIGITO ACTUAL
    push dx              ;SE APILA EL DIGITO
    inc  cx
    cmp  ax, 0
    jne  pn_div

pn_print:
    pop  dx
    add  dl, '0'         ;CONVERTIR DE NUMERO A ASCII PARA IMPRIMIRLO
    mov  ah, 02h
    int  21h
    loop pn_print

    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_num ENDP

;---------------------------------------------
;LOS SIGUIENTES 4 PROCEDIMIENTOS REALIZAN CADA OPERACION
;LOS NUMEROS SE GUARDAN EN SI (n1) Y DI (n2) 
;LOS push Y pop SE USAN PARA QUE LOS PROC NO SOBREESCRIBAN A AX

;PROCEDIMIENTO DE SUMA
hacer_suma PROC
    mov  ax, si
    add  ax, di          ;AX = n1 + n2
    push ax
    print result
    pop ax
    call print_num
    print salto
    ret
hacer_suma ENDP

;PROCEDIMIENTO DE RESTA
hacer_resta PROC
    cmp  si, di
    jb   resta_neg       ;SI n1 < n2, EL RESULTADO ES NEGATIVO

    ;SI n1 >= n2 EL RESULTADO ES POSITIVO, SE HACE NORMAL
    mov  ax, si
    sub  ax, di
    push ax
    print result
    pop  ax
    call print_num
    print salto
    ret

resta_neg:
    ;SI ES NEGATIVO SE IMPRIME EL SIGNO PRIMERO
    ;Y SE CALCULA n2-n1 PARA QUE NO SE DESBORDE EL REGISTRO
    mov  ax, di
    sub  ax, si          ;SIEMPRE DA POSITIVO TONS NO HAY PROBLEMA
    push ax
    print result
    print negativo       ;PRIMERO EL SIGNO MENOS
    pop  ax
    call print_num
    print salto
    ret
hacer_resta ENDP

;PROCEDIMIENTO DE MULTIPLICACION
hacer_mult PROC
    mov  ax, si
    mov  bx, di
    mul  bx              ;DX:AX = n1 * n2
    push ax
    print result
    pop ax
    call print_num       ;SOLO SE USA LA PARTE BAJA EN AX
    print salto
    ret
hacer_mult ENDP
 
;PROCEDIMIENTO DE DIVISION
hacer_div PROC
    cmp  di, 0
    je   div_cero        ;SI n2=0 NO SE PUEDE DIVIDIR
    xor  dx, dx
    mov  ax, si
    div  di              ;AX = COCIENTE, DX = RESIDUO
    push ax
    print result
    pop ax
    call print_num
    print salto
    ret
div_cero:
    print err_div
    ret
hacer_div ENDP

;--------------------------------
;INICIO DEL PROGRAMA
inicio:
    mov ax, DATA
    mov ds, ax

menu:
    ;AQUI SE LEEN LOS DOS NUMEROS
    ;SE GUARDAN EN SI Y DI PARA NO NECESITAR VARIABLES
    print mensj1
    leer  n1
    lea   bx, n1
    call  convertir
    mov   si, ax         ;SI = PRIMER NUMERO

    print mensj2
    leer  n2
    lea   bx, n2
    call  convertir
    mov   di, ax         ;DI = SEGUNDO NUMERO

    print opciones

pedir_op:
    mov  ah, 01h
    int  21h             ;LEER LA TECLA CON ECO EN PANTALLA

    cmp  al, '1'
    je   op_suma
    cmp  al, '2'
    je   op_resta
    cmp  al, '3'
    je   op_mult
    cmp  al, '4'
    je   op_div

    ;SI NO ES NINGUNA DE LAS 4 OPCIONES, SE PIDE DE NUEVO
    print err_op
    jmp  pedir_op

op_suma:
    call hacer_suma
    jmp  preguntar
op_resta:
    call hacer_resta
    jmp  preguntar
op_mult:
    call hacer_mult
    jmp  preguntar
op_div:
    call hacer_div

preguntar:
    print otra
    mov  ah, 01h
    int  21h
    cmp  al, 'S'
    je   menu
    cmp  al, 's'
    je   menu

    mov  ax, 4C00h
    int  21h

CODE ENDS
END inicio