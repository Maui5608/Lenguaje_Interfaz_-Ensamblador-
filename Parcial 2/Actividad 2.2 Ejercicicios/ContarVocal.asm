;ACTIVIDAD 2.2. EJERCICIOS
;-------------------------
;DAVID EZEQUIEL CABALLERO GONZALEZ
;-------------------------
;LENGUAJE DE INTERFAZ
;-------------------------
;CODIGO 4: LEER UNA PALABRA DE 10 CARACTERES Y 
;CONTAR CUANTAS VOCALES HAY, MODIFICANDO EL
;CODIGO DE CADENA02.asm
;-------------------------
;CODIGOS UTILIZADOS:
;CADENA02: CODIGO BASE CON LA LOGICA DE LEER 10 CARACTERES
;1 POR 1.
;COMPA02.asm: CODIGO CON LA LOGICA DE COMPARAR CADA CARACTER                                               

STACK SEGMENT STACK
    DB 64 DUP(?)
STACK ENDS

DATA SEGMENT
    cadena DB 10 DUP(' '), '$'
    txt0 db 'Ingrese la palabra (max de 10): ',10,13,'$'
    txt1 db 13,10,'Vocales encontradas: $'
    txt2 db '10$' 
DATA ENDS

CODE SEGMENT
    ASSUME DS:DATA, CS:CODE, SS:STACK

INICIO:
    MOV AX, DATA
    MOV DS, AX

    ;CONFIGURAR QUE EL BUCLE Leer SE REPITA 10 VECES 
    MOV CX, 10
    MOV SI, 0
    
    ;INICIALIZAR BX EN '0' PARA CONTAR LAS VOCALES
    MOV BL, '0'
    
    ;PEDIR PALABRA AL USUARIO
    MOV AH, 09H
    MOV DX, OFFSET txt0 
    INT 21H
    
Leer:
    
    ;VALIDAR TECLA ENTER
    CMP AL, 0DH
    JE Final
    
    ;LEER CARACTER SIN ECO
    MOV AH, 07H
    INT 21H
    
    ;GUARDAR EL CARACTER EN EL ARREGLO
    MOV cadena[SI], AL
    
    ;COMPARACIONES CON VOCALES
    CMP AL, 'A'
    JE EsVocal
    CMP AL, 'a'
    JE EsVocal
    CMP AL, 'E'
    JE EsVocal
    CMP AL, 'e'
    JE EsVocal
    CMP AL, 'I'
    JE EsVocal
    CMP AL, 'i'
    JE EsVocal
    CMP AL, 'O'
    JE EsVocal
    CMP AL, 'o'
    JE EsVocal
    CMP AL, 'U'
    JE EsVocal
    CMP AL, 'u'
    JE EsVocal
    
    JMP Final 
    
EsVocal:
    ;INCREMENTAR EN 1 A BL CADA VEZ QUE HAY UNA COINCIDENCIA
    INC BL
    
    ;CAPTURACION DE ERRROR CUANDO SE ESCRIBEN 10 VOCALES
    CMP BL, ':'
    JE Otrofinal
    
Final:    
    ;MOSTRAR CARACTER
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    
    ;REPETIR CICLO HASTA CONTAR 10 CARACTERES
    LOOP Leer

    
    ;IMPRRIMIR txt1
    MOV AH, 09H
    MOV DX, OFFSET txt1
    INT 21H 
    
    ;IMPRIMIR NUMERO DE VOCALES
    MOV DL, BL
    MOV AH, 02H
    INT 21H
    
    JMP Finalizar

Otrofinal:
    ;IMPRRIMIR txt1
    MOV AH, 09H
    MOV DX, OFFSET txt1
    INT 21H     
    
    ;IMPRRIMIR txt2
    MOV AH, 09H
    MOV DX, OFFSET txt2
    INT 21H 

Finalizar:
    ;FINALIZAR
    MOV AX, 4C00H
    INT 21H
    

CODE ENDS
END INICIO