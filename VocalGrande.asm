;ACTIVIDAD 2.2. EJERCICIOS
;-------------------------
;DAVID EZEQUIEL CABALLERO GONZALEZ
;-------------------------
;LENGUAJE DE INTERFAZ
;-------------------------
;CODIGO2: PROGRAMA PARA LEER UNA CADENA Y MOSTRAR LA
;PRIMERA VOCAL EN GRANDE Y EN COLOR ROJO
;-------------------------
;CODIGOS UTILIZADOS:
;GRANDE.asm: CODIGO BASE PARA IMPRIMIR CARACTERES GRANDES
;CADENA02.asm: CODIGO CON LA LOGICA DE LEER CADENAS LETRA POR LETRA
;COLOR1.asm: CODIGO CON LA LOGICA DE PONER COLOR A LA LETRA


PILA SEGMENT STACK
DB 64 DUP('PILA')
PILA ENDS

DATOS SEGMENT
    cadena DB 10 DUP(' '), '$'
    txt1 db 'Escribe una palabra (max:10):',10,13, '$'
    txt2 db 10,13,'La primera vocal de la palabra es: $',10,13
    txt0 db 10,13,'No hay vocales en la palabra$' 

    vcala db 13,10,'   ###   ',13,10,'  ## ##  ',13,10,' ##   ## ',13,10,' ####### ',13,10,' ##   ## ',13,10,' ##   ## ',13,10,' ##   ## ',13,10,'$'

    vcale db 13,10,' ####### ',13,10,' ##      ',13,10,' ##      ',13,10,' #####   ',13,10,' ##      ',13,10,' ##      ',13,10,' ####### ',13,10,'$'

    vcali db 13,10,' ####### ',13,10,'   ##    ',13,10,'   ##    ',13,10,'   ##    ',13,10,'   ##    ',13,10,'   ##    ',13,10,' ####### ',13,10,'$'
    
    vcalo db 13,10,'  #####  ',13,10,' ##   ## ',13,10,' ##   ## ',13,10,' ##   ## ',13,10,' ##   ## ',13,10,' ##   ## ',13,10,'  #####  ',13,10,'$'
    
    vcalu db 13,10,' ##   ## ',13,10,' ##   ## ',13,10,' ##   ## ',13,10,' ##   ## ',13,10,' ##   ## ',13,10,' ##   ## ',13,10,'  #####  ',13,10,'$'
    

DATOS ENDS

CODIGO SEGMENT
ASSUME CS:CODIGO, DS:DATOS, SS:PILA 

;INICIO DEL PROGRAMA
INICIO: 
 
    ;INICIALIZACION DE DS
    mov ax, DATOS
    MOV DS, AX
    
    
    ;PREPARAR CONTADOR Y CICLO
    MOV CX, 10
    MOV SI, 0 
    
    ;PEDIR PALABRA      
    MOV DX, OFFSET txt1
    MOV AH, 09H
    INT 21H 
     
    
Leer:
     
    ;LEER CARACTER SIN ECO
    MOV AH, 07H
    INT 21H
    
    ;VALIDAR TECLA ENTER
    CMP AL, 0DH
    JE PreBuscar 
    
    ;MOSTRAR CARACTER   
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    
    ;GUARDAR EL CARACTER
    MOV cadena[SI], AL
    INC SI
    
    
    ;REPETIR 10 VECES
    Loop Leer
    
    

PreBuscar:
    ;GUARDAR CUANTOS CARACTERES HAY
    CMP SI, 0
    JE Final
    
    MOV CX, SI   
    MOV SI, 0   

Buscar:
    
    ;COMPARAR PRIMER CARACTER
    MOV AL, cadena[SI] 
     
    ;COMPARACIONES CON VOCALES
    CMP AL, 'A'
    JE A
    CMP AL, 'a'
    JE A 
    CMP AL, 'E'
    JE E
    CMP AL, 'e'
    JE E
    CMP AL, 'I'
    JE I
    CMP AL, 'i'
    JE I
    CMP AL, 'O'
    JE O
    CMP AL, 'o'
    JE O
    CMP AL, 'U'
    JE U
    CMP AL, 'u'
    JE U
    
    
    ;PASAR A LA SIGUIENTE LETRA SI NO SE ENCONTRO NI UNA VOCAL
    INC SI
    
    ;REPETIR 10 VECES
    LOOP Buscar

    ;SI NO HAY VOCALES, TERMINAR
    JMP Final

;IMPRIMIR PRIMERA VOCAL QUE LEA EN ROJO
A:  
    ;IMPRIMIR txt2
    MOV DX, OFFSET txt2
    MOV AH, 09H
    INT 21H
    
    ;CAMBIAR COLOR
    MOV AH, 09H
    MOV AL, ' '
    MOV BH, 0
    MOV BL, 0Ch
    MOV CX, 1000
    INT 10H
    
    ;IMPRIMIR VOCAL
    MOV DX, OFFSET vcala
    MOV AH, 09H
    INT 21H
  
    JMP Finalizar

E:  
    ;IMPRIMIR txt2
    MOV DX, OFFSET txt2
    MOV AH, 09H
    INT 21H
    
    ;CAMBIAR COLOR
    MOV AH, 09H
    MOV AL, ' '
    MOV BH, 0
    MOV BL, 0Ch
    MOV CX, 1000
    INT 10H
    
    ;IMPRIMIR VOCAL
    MOV DX, OFFSET vcale
    MOV AH, 09H
    INT 21H
  
    JMP Finalizar

I:  
    ;IMPRIMIR txt2
    MOV DX, OFFSET txt2
    MOV AH, 09H
    INT 21H
    
    ;CAMBIAR COLOR
    MOV AH, 09H
    MOV AL, ' '
    MOV BH, 0
    MOV BL, 0Ch
    MOV CX, 1000
    INT 10H
    
    ;IMPRIMIR VOCAL
    MOV DX, OFFSET vcali
    MOV AH, 09H
    INT 21H
  
    JMP Finalizar

O:  
    ;IMPRIMIR txt2
    MOV DX, OFFSET txt2
    MOV AH, 09H
    INT 21H
    
    ;CAMBIAR COLOR
    MOV AH, 09H
    MOV AL, ' '
    MOV BH, 0
    MOV BL, 0Ch
    MOV CX, 1000
    INT 10H
    
    ;IMPRIMIR VOCAL
    MOV DX, OFFSET vcalo
    MOV AH, 09H
    INT 21H
  
    JMP Finalizar

U:  
    ;IMPRIMIR txt2
    MOV DX, OFFSET txt2
    MOV AH, 09H
    INT 21H
    
    ;CAMBIAR COLOR
    MOV AH, 09H
    MOV AL, ' '
    MOV BH, 0
    MOV BL, 0Ch
    MOV CX, 1000
    INT 10H
    
    ;IMPRIMIR VOCAL
    MOV DX, OFFSET vcalu
    MOV AH, 09H
    INT 21H
  
    JMP Finalizar

Final:
    MOV DX, OFFSET txt0
    MOV AH, 09H
    INT 21H

Finalizar:
    MOV AX, 4C00H
    INT 21H

CODIGO ENDS
END INICIO