;-------------------------
;DAVID EZEQUIEL CABALLERO GONZALEZ
;-------------------------
;LENGUAJE DE INTERFAZ
;-------------------------
;EXAMEN PARCIAL 2 LENGUAJE DE INTERFAZ
;CODIGO 2: CONVERTIR PALABRA A MAYUSCULAS 

STACK SEGMENT STACK
    DB 64 DUP(?)
STACK ENDS

DATA SEGMENT
    cadena DB 12 DUP(' '), '$'
    txt0 db 13,10,'Ingrese la palabra de 12 caracteres: $'
    txt1 db 13,10,'Palabra en mayusculas: $'
    txt2 db 13,10,'Solo letras minusculas', 13,10,'$' 
    txt3 db 13,10,'La palabra debe ser de 12 caracteres',13,10,'$'
DATA ENDS

CODE SEGMENT
    ASSUME DS:DATA, CS:CODE, SS:STACK

INICIO:
    MOV AX, DATA
    MOV DS, AX

    ;CONFIGURAR QUE EL BUCLE Leer SE REPITA 12 VECES 
    MOV CX, 12
    MOV SI, 0
    MOV DI, 0

    ;PEDIR PALABRA AL USUARIO
    MOV AH, 09H
    MOV DX, OFFSET txt0
    INT 21H
    
Leer:   

    ;LEER CARACTER SIN ECO
    MOV AH, 07H
    INT 21H
    
    ;VALIDAR TECLA ENTER
    CMP AL, 0DH     
    JE enter
    
    ;VALIDAR QUE SOLO ADMITA LETRAS MINUSCULAS
    CMP AL, 97
    JB final2       
    
    CMP AL, 122
    JA final2
    
    
    ;GUARDAR EL CARACTER EN EL ARREGLO
    MOV cadena[SI], AL
    
   
    ;MOSTRAR CARACTER
    MOV DL, AL
    MOV AH, 02H
    INT 21H  
    
    ;GUARDAR EN MAYUSCULA EN DI
    SUB AL, 32
    MOV cadena[DI], AL
    
    INC SI
    INC DI
    
    ;REPETIR CICLO HASTA CONTAR 12 CARACTERES
    LOOP Leer 
       
    ;IMPRRIMIR txt1
    MOV AH, 09H
    MOV DX, OFFSET txt1
    INT 21H
    
    ;IMPRIMIR PALABRA EN MAYUSCULAS
    MOV AH, 09H
    MOV DX, OFFSET cadena
    INT 21H
    
    JMP Finalizar     
                  
final2:
    ;IMPRRIMIR txt2
    MOV AH, 09H
    MOV DX, OFFSET txt2
    INT 21H
    
    JMP Leer
    
enter:
;IMPRRIMIR txt3
    MOV AH, 09H
    MOV DX, OFFSET txt3
    INT 21H
    
    JMP Leer
                         
Finalizar:
    ;FINALIZAR
    MOV AX, 4C00H
    INT 21H
    

CODE ENDS
END INICIO