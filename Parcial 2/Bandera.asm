;ACTIVIDAD 2.2. EJERCICIOS
;-------------------------
;DAVID EZEQUIEL CABALLERO GONZALEZ
;-------------------------
;LENGUAJE DE INTERFAZ
;-------------------------
;CODIGO1: PROGRAMA PARA CREAR UNA BANDERA (UCRANIA)
;-------------------------
;CODIGOS UTILIZADOS:
;CUADRO.asm: CODIGO BASE CON LA LOGICA DE CREAR CUADROS

PILA SEGMENT STACK
DB 64 DUP('PILA')
PILA ENDS

CODIGO SEGMENT
ASSUME CS:CODIGO,SS:PILA

INICIO:

;Rectangulo azul de arriba
mov cx, 0000h   
mov dx, 0C4Fh   
xor al, al
mov bh, 1Eh     
mov ah, 6
int 10h

;Rectangulo amarillo
mov cx, 0D00h   
mov dx, 184Fh   
xor al, al
mov bh, 6Eh     
mov ah, 6
int 10h
      
;Esperar tecla    
mov ah,1h
int 21h

;Terminar
mov ah, 4ch
int 21h


CODIGO ENDS
END INICIO