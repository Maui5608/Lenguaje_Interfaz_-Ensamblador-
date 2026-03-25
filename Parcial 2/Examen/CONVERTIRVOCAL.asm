;DAVID EZEQUIEL CABALLERO GONZALEZ
;-------------------------
;LENGUAJE DE INTERFAZ
;-------------------------
;EXAMEN PARCIAL 2 LENGUAJE DE INTERFAZ
;CODIGO 3: LEER UNA CADENA Y CONVERTIR VOCALES A *
;------------------------- 

STACK SEGMENT STACK
    DB 64 DUP(?)
STACK ENDS

DATA SEGMENT
    cadena DB 10 DUP(' '), '$'
    txt0 db 'Ingrese una cadena (max: 10): ',13,10,'$'
    txt1 db 13,10,'Vocales encontradas: $'
    txt2 db '10$' 
DATA ENDS

CODE SEGMENT
    ASSUME DS:DATA, CS:CODE, SS:STACK

INICIO:
    MOV AX, DATA
    MOV DS, AX

    MOV CX, 10
    MOV SI, 0
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
    
    ;GUARDAR EL CARACTER ORIGINAL EN EL ARREGLO
    MOV cadena[SI], AL
    INC SI
    
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
    
    ;SI NO ES VOCAL, SE GUARDA EL CARACTER
    MOV DL, AL
    JMP Final
    
EsVocal:   

    ;INCREMENTAR EL CONTADOR DE VOCALES
    INC BL 
    
    ;PREPARAR * PARA IMPRIMIR
    MOV DL, '*'
    
    ;CAPTURA DE ERROR CUANDO HAY 10 VOCALES
    CMP BL, ':'
    JE Otrofinal

Final:    
    ; MOSTRAR CARACTER
    MOV AH, 02H
    INT 21H
    
    LOOP Leer

    ;IMPRIMIR TEXTO DE RESULTADO
    MOV AH, 09H
    MOV DX, OFFSET txt1
    INT 21H 
    
    ;IMPRIMIR NUMERO DE VOCALES
    MOV DL, BL
    MOV AH, 02H
    INT 21H
    
    JMP Finalizar

Otrofinal:
    ;FINAL CUANDO HAY 10 VOCALES
    MOV AH, 09H
    MOV DX, OFFSET txt1
    INT 21H      
    
    MOV AH, 09H
    MOV DX, OFFSET txt2
    INT 21H 

Finalizar:
    MOV AX, 4C00H
    INT 21H
    
CODE ENDS
END INICIO