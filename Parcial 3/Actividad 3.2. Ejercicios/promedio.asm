;-------------------------
;DAVID EZEQUIEL CABALLERO GONZALEZ
;-------------------------
;LENGUAJE DE INTERFAZ
;------------------------- 
;PROFESOR: DR. ALEJANDRO SAGUNDO DUARTE 
;-------------------------
;ACTIVIDAD 3.2 EJERCICIOS
;-------------------------
;PROGRAMA 1. PROMEDIO

STACK SEGMENT STACK
    DW 64 DUP(?)
STACK ENDS

DATA SEGMENT
    mensj1  db 13,10,"Nombre del alumno: $"
    mensj2   db 13,10,"Calificacion 1 (max 100): $"
    mensj3   db 13,10,"Calificacion 2 (max 100): $"
    mensj4   db 13,10,"Calificacion 3 (max 100): $"
    aprobado db " esta aprobado con: $"
    reprobado db " esta reprobado con: $"  
    error db 13,10,"la calificacion maxima es de 100$"
    SALTO    db 13,10,"$"

    nombre  db 31,0,30 DUP(0),'$';CONSIDERE QUE HAY NOMBRES LARGOS, 
                                 ;TONS POR ESO PUSE MUCHO ESPACIO PARA EL NOMBRE. 
                                 ;EN ESTE CASO, 30 caracteres max .  
    
    c1   db  5,0, 4 DUP(0),'$';PARA LAS CALIFICACIONES NO SE NECESITA 
    c2   db  5,0, 4 DUP(0),'$';MUCHO ESPACIO, TONS PUSE MAX 4 CARACTERES
    c3   db  5,0, 4 DUP(0),'$';PORQUE LA CALIFICACION MAXIMA ES 100
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
;PROCEDIMIENTO PARA CONVERTIR DE VALOR ASCII A NUMERO
convertir PROC
    push bx             ;SE USARON 4 INSTR PUSH PARA QUE
    push cx             ;CADA UNO GUARDE EL VALOR DEL REGISTRO
    push dx             ;EN LA PILA ANTES DE QUE EL PROCEDIMIENTO
    push si             ;LOS MODIFIQUE

    xor  ax, ax          ;AQUI EL AX SE IGUALA A 0
    xor  si, si          ;AQUI SI=0 PARA INDICAR EL CARACTER ACTUAL
    mov  cl, [bx+1]      ;AQUI SE CAPTURA CUANTOS CARACTERES SE LEYERON
    xor  ch, ch
    cmp  cx, 0
    je   conv_fin

conv_loop:
    push cx              
    mov  cx, 10
    mul  cx              ;AQUI POR CADA DIGITO MULTIPLICA LO ACUMULADO POR 10
    pop  cx              ;Y SE SUMA AL NUEVO DIGITO
    xor  dx, dx
    mov  dl, [bx+2+si]   
    sub  dl, '0'        
    add  ax, dx
    inc  si
    loop conv_loop

conv_fin:
    pop si
    pop dx            ;AQUI SE RESTAURAN LOS REGISTROS Y REGRESA
    pop cx            ;EL RESULTADO SE QUEDA EN AX
    pop bx
    ret
convertir ENDP

;---------------------------------------------
;PROCEDIMIENTO PARA IMPRIMIR EL NUM EN DECIMAL
print_num PROC
    push ax
    push bx
    push cx
    push dx

    mov  bx, 10
    xor  cx, cx          ;AQUI SE CUENTAN LOS DIGITOS

pn_div:
    xor  dx, dx
    div  bx              ;AQUI SE DIVIDE REPETIDAMENTE ENTRE 10
    push dx              ;APILANDO CADA DIGITO
    inc  cx
    cmp  ax, 0
    jne  pn_div

pn_print:
    pop  dx
    add  dl, '0'         ;AQUI SE DESAPILA EN ORDEN INVERSO E IMPRIME
    mov  ah, 02h         ;QUEDANDO EL NUMERO CORRECTO
    int  21h
    loop pn_print

    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_num ENDP
    
;----------------------------------------------    
;PROCEDIMIENTO PARA IMPRIMIR LAS CALIFICACIONES
print_cal PROC
    push bx
    push cx
    push dx
    push si

    mov  cl, [bx+1]      ;AQUI SE CUENTAN LOS CARACTERES A LEER
    xor  ch, ch
    cmp  cx, 0
    je   pc_fin
    mov  si, 2           ;ENPEZANDO DESDE offset 2 DONDE ESTAN LOS DATOS

pc_loop:
    mov  dl, [bx+si]     ;TOMA EL CARACTER
    mov  ah, 02h         ;PARA LUEGO IMPRIMIRLO
    int  21h
    inc  si
    loop pc_loop

pc_fin:
    pop si
    pop dx
    pop cx
    pop bx
    ret
print_cal ENDP 
 
;------------------------------------------------------------------- 
;PROCEDIMIENTO PARA VALIDAR QUE LA CALIFICACION NO SEA MAYOR QUE 100
validar PROC
    cmp ax, 100
    ja  cal_invalido          ;AQUI SIMPLEMENTE SE USA EL
    clc                       ;Carry Flag PARA QUE CF=O SEA VALIDO
    ret                       ;Y CF=1 SEA INVALIDO
cal_invalido:
    stc
    ret
validar ENDP


;INICIO DEL PROGRAMA
inicio:
    mov ax, DATA
    mov ds, ax
 
    print mensj1
    leer  nombre
 
    xor  si, si         ;AQUI SE INICIALIZA EL ACUMULADOR DE LA SUMA
 
leer_c1:
    print mensj2
    leer  c1
    lea   bx, c1
    call  convertir
    call  validar
    jc    err_c1
    add   si, ax
    jmp   leer_c2
err_c1:                  ;PARA CADA CALIFICACION, SE LEE
    print error          ;SE VALIDA QUE NO SEA MAYOR A 100
    jmp   leer_c1        ;Y SE SUMA O GUARDA AL SI

 
leer_c2:                 
    print mensj3
    leer  c2
    lea   bx, c2
    call  convertir
    call  validar
    jc    err_c2
    add   si, ax
    jmp   leer_c3
err_c2:
    print error
    jmp   leer_c2
 
leer_c3:
    print mensj4
    leer  c3
    lea   bx, c3
    call  convertir
    call  validar
    jc    err_c3
    add   si, ax
    jmp   continuar
err_c3:
    print error
    jmp   leer_c3

continuar:
 
    ;CALCULAR PROMEDIO
    mov  ax, si        ;LA SUMA DE LAS 3 CALIFICACIONES SE GUARDA EN AX
    xor  dx, dx        ;SE LIMPIA DX PARA QUE div PUEDA USARLO
    mov  bx, 3
    div  bx            ;EL COCIENTE SE QUEDA EN AX
    mov  si, ax        ;PERO LUEGO SE GUARDA EN SI
    
    
    ;IMPRIMIR RESULTADO
    print SALTO
    lea   bx, nombre
    call  print_cal
 
    cmp  si, 70
    jl   es_reprobado
 
    ;APROBADO
    print aprobado
    mov  ax, si
    call print_num
    jmp  fin_prog
 
    ;REPROBADO
es_reprobado:
    print reprobado
    mov  ax, si
    call print_num
 
fin_prog:
    mov ax, 4C00h
    int 21h
 
CODE ENDS
END inicio
