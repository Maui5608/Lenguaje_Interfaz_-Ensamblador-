;-------------------------
;DAVID EZEQUIEL CABALLERO GONZALEZ
;-------------------------
;LENGUAJE DE INTERFAZ
;------------------------- 
;PROFESOR: DR. ALEJANDRO SAGUNDO DUARTE 
;-------------------------
;ACTIVIDAD 3.2 EJERCICIOS
;-------------------------
;PROGRAMA 3. COORDENADA

STACK SEGMENT STACK
    DW 64 DUP(?)
STACK ENDS

DATA SEGMENT
    mensj1  db 13,10,"Ingresa la cadena (max 15 chars): $"
    mensj2  db 13,10,"Fila    (0-24): $"
    mensj3  db 13,10,"Columna (0-79): $"
    error   db 13,10,"Coordenada fuera de rango, intenta de nuevo$"
    otra    db 13,10,"Otra cadena? (S/N): $"
    salto   db 13,10,"$"

    ;PUSE COMO MAXIMO 15 CARACTERES PARA QUE NO SEA NI MUCHO NI POCO
    cadena  db 16,0,15 DUP(0),'$'

    ;FILA MAX 2 DIGITOS (24), COLUMNA MAX 2 DIGITOS (79)
    ;TONS CON 3 BYTES ALCANZA PARA CADA UNO
    buf_fil db 3,0,2 DUP(0),'$'
    buf_col db 3,0,2 DUP(0),'$'

    ;AQUI SE GUARDAN LA FILA Y COLUMNA YA CONVERTIDAS A NUMERO
    fila    db 0
    columna db 0
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

;----------------------------------------------------
;PROCEDIMIENTO PARA CONVERTIR ASCII A NUMERO
convertir PROC
    push bx
    push cx
    push dx
    push si

    xor  ax, ax
    xor  si, si
    mov  cl, [bx+1]      ;CUANTOS CARACTERES SE LEYERON
    xor  ch, ch
    cmp  cx, 0
    je   conv_fin

conv_loop:
    push cx
    mov  cx, 10
    mul  cx              ;AQUI SE MULTIPLICA LO ACUMULADO POR 10
    pop  cx
    xor  dx, dx
    mov  dl, [bx+2+si]
    sub  dl, '0'         ;ASCII A NUMERO
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
;PROCEDIMIENTO PARA POSICIONAR EL CURSOR
mover_cursor PROC
    mov ah, 02h
    mov bh, 0           ;DH = FILA, DL = COLUMNA 
    int 10h
    ret
mover_cursor ENDP

;---------------------------------------------
;PROCEDIMIENTO PARA LIMPIAR LA PANTALLA
limpiar PROC
    mov ax, 0600h        ;06h = SCROLL, 00 = TODA LA VENTANA
    mov bh, 07h          ;ATRIBUTO NORMAL (BLANCO SOBRE NEGRO)
    mov cx, 0000h        ;ESQUINA SUPERIOR IZQUIERDA
    mov dx, 184Fh        ;ESQUINA INFERIOR DERECHA (FILA 24, COL 79)
    int 10h
    mov dh, 0            ;REGRESAR CURSOR AL (0,0)
    mov dl, 0
    call mover_cursor
    ret
limpiar ENDP

;---------------------------------------------
;PROCEDIMIENTO PARA IMPRIMIR LA CADENA EN LA POSICION INDICADA
;SE USA INT 10h/0Eh PARA NO PERDER LA POSICION DEL CURSOR
print_pos PROC
    push bx
    push cx
    push dx
    push si

    ;PRIMERO SE POSICIONA EL CURSOR EN FILA,COLUMNA
    mov dh, fila
    mov dl, columna
    call mover_cursor

    ;LUEGO SE IMPRIME CARACTER POR CARACTER
    mov cl, cadena[1]    ;CUANTOS CARACTERES TIENE LA CADENA
    xor ch, ch
    cmp cx, 0
    je  pp_fin
    mov si, 2            ;LOS DATOS EMPIEZAN EN OFFSET 2

pp_loop:
    mov al, cadena[si]
    mov ah, 0Eh          ;0Eh = IMPRIMIR CARACTER SIN MOVER DE LINEA
    mov bh, 0
    int 10h
    inc si
    loop pp_loop

pp_fin:
    pop si
    pop dx
    pop cx
    pop bx
    ret
print_pos ENDP

;---------------------------------------------
;PROCEDIMIENTO PARA LEER Y VALIDAR LAS COORDENADAS
leer_coords PROC
    ;LEER FILA Y VALIDAR QUE SEA ENTRE 0 Y 24
    print mensj2
    leer  buf_fil
    lea   bx, buf_fil
    call  convertir      ;AX = FILA INGRESADA
    cmp   ax, 24
    ja    lc_error       ;SI ES MAYOR A 24, ES INVALIDA
    mov   fila, al

    ;LEER COLUMNA Y VALIDAR QUE SEA ENTRE 0 Y 79
    print mensj3
    leer  buf_col
    lea   bx, buf_col
    call  convertir      ;AX = COLUMNA INGRESADA
    cmp   ax, 79
    ja    lc_error       ;SI ES MAYOR A 79, ES INVALIDA
    mov   columna, al

    clc                  ;CF=0 SIGNIFICA QUE LAS COORDENADAS SON VALIDAS
    ret

lc_error:
    stc                  ;CF=1 SIGNIFICA QUE ESTAN FUERA DE RANGO
    ret
leer_coords ENDP

;-----------------------------------------------
;INICIO DEL PROGRAMA
inicio:
    mov ax, DATA
    mov ds, ax

    call limpiar

ciclo:
    ;LEER LA CADENA QUE SE VA A MOSTRAR
    print mensj1
    leer  cadena

    ;LEER LAS COORDENADAS CON VALIDACION
    ;SI SON INVALIDAS SE PIDEN DE NUEVO
pedir_coord:
    call leer_coords
    jc   coord_mal
    jmp  mostrar
coord_mal:
    print error
    jmp  pedir_coord

mostrar:
    call print_pos       ;IMPRIMIR LA CADENA EN LA POSICION INDICADA

    ;REGRESAR EL CURSOR A UNA ZONA SEGURA PARA EL MENU
    mov dh, 22
    mov dl, 0
    call mover_cursor
    print salto

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