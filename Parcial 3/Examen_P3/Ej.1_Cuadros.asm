;-------------------------
;DAVID EZEQUIEL CABALLERO GONZALEZ
;-------------------------
;LENGUAJE DE INTERFAZ
;------------------------- 
;PROFESOR: DR. ALEJANDRO SAGUNDO DUARTE 
;-------------------------
;EXAMEN U3
;-------------------------  
;EJERCICIO 1. CUADROS CON MARCO AMARILLO

STACK SEGMENT STACK
    DW 64 DUP(?)
STACK ENDS

DATA SEGMENT
    mensj1  db 13,10,"Ingresa tu nombre (max 15): $"
    mensj2  db 13,10,"Ingresa tu apellido (max 15): $"

    mensj3 db "INGENIERO$"

    nombre   db 16,0,15 DUP(0),'$'
    apellido db 16,0,15 DUP(0),'$'
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

;MACRO PARA LEER
leer MACRO buf
    mov ah, 0Ah
    lea dx, buf
    int 21h
ENDM

;----------------------------------------------------   
;PROCEDIMIENTO PARA LIMPIAR
limpiar PROC
    mov ax, 0600h
    mov bh, 07h
    mov cx, 0000h
    mov dx, 184Fh
    int 10h
    mov ah, 02h
    mov bh, 0
    mov dx, 0000h
    int 10h
    ret
limpiar ENDP

;---------------------------------------------------- 
;PROCEDIMIENTO PARA DIBUJAR EL CUADRO
dibujar_cuadro PROC
    mov ax, 0600h
    int 10h
    ret
dibujar_cuadro ENDP

;----------------------------------------------------
;PROCEDIMIENTO PARA MOVER EL CURSOR
mover_cursor PROC
    mov ah, 02h
    mov bh, 0
    int 10h
    ret
mover_cursor ENDP

;----------------------------------------------------
;PROCEDIMIENTO PARA IMPRIMIR CENTRADO 
print_centrado PROC
    push bx
    push cx
    push dx
    push si

    xor  cx, cx
    mov  cl, [bx+1]
    shr  cl, 1
    sub  dl, cl

    call mover_cursor

    xor  cx, cx
    mov  cl, [bx+1]
    mov  si, 2

pc_loop:
    push cx              ;GUARDAR CONTADOR ANTES DE INT 21h
    mov  dl, [bx+si]
    mov  ah, 02h
    int  21h
    pop  cx              ;RECUPERAR CONTADOR DESPUES DE INT 21h
    inc  si
    loop pc_loop

    pop si
    pop dx
    pop cx
    pop bx
    ret
print_centrado ENDP

;---------------------------------------------------- 

print_fijo_centrado PROC
    push dx
    push si

    shr  cl, 1
    sub  dl, cl
    call mover_cursor

    mov  ah, 09h
    mov  dx, si
    int  21h

    pop si
    pop dx
    ret
print_fijo_centrado ENDP

;----------------------------------------------------
retardo PROC
    push cx
    push dx

    mov  cx, 0002h

retardo_ext:
    mov  dx, 0002h
retardo_int:
    sub  dx, 1
    cmp  dx, 0
    jne  retardo_int
    sub  cx, 1
    cmp  cx, 0
    jne  retardo_ext

    pop dx
    pop cx
    ret
retardo ENDP

;---------------------------------------------------------
inicio:
    mov ax, DATA
    mov ds, ax

    call limpiar

    print mensj1
    leer  nombre

    print mensj2
    leer  apellido

    call limpiar

    mov  ax, 1003h
    mov  bx, 0000h
    int  10h

    ;CUADRO 1. AZUL
    mov bh, 0EEh         
    mov cx, 0202h        
    mov dx, 081Ah        
    call dibujar_cuadro

    mov bh, 1Eh          
    mov cx, 0303h        
    mov dx, 0719h        
    call dibujar_cuadro

    
    mov  dh, 5
    mov  dl, 14
    lea  si, mensj3
    mov  cl, 9
    call print_fijo_centrado

    call retardo

    ;CUADRO 2. VERDE
    mov bh, 0EEh
    mov cx, 0710h        
    mov dx, 0D2Ah        
    call dibujar_cuadro

    mov bh, 20h          
    mov cx, 0811h        
    mov dx, 0C29h        
    call dibujar_cuadro

    lea  bx, nombre
    mov  dh, 10
    mov  dl, 29
    call print_centrado

    call retardo

    ;CUADRO 3. ROJO
    mov bh, 0EEh
    mov cx, 0C1Eh        
    mov dx, 123Ah        
    call dibujar_cuadro

    mov bh, 4Fh          
    mov cx, 0D1Fh        
    mov dx, 1139h        
    call dibujar_cuadro

    lea  bx, apellido
    mov  dh, 15
    mov  dl, 44
    call print_centrado

    mov ah, 01h
    int 21h

    mov ax, 4C00h
    int 21h

CODE ENDS
END inicio