;-------------------------
;DAVID EZEQUIEL CABALLERO GONZALEZ
;-------------------------
;LENGUAJE DE INTERFAZ
;------------------------- 
;PROFESOR: DR. ALEJANDRO SAGUNDO DUARTE 
;-------------------------
;ACTIVIDAD 3.2 EJERCICIOS
;-------------------------
;PROGRAMA 5. VOCAL_GRANDE

STACK SEGMENT STACK
    DW 64 DUP(?)
STACK ENDS

DATA SEGMENT
    instruc db "Presiona una vocal (a,e,i,o,u)",13,10
            db "ESC para salir",13,10,"$"
    err     db 13,10,"No es una vocal, intenta de nuevo$"
    adios   db 13,10,"Hasta luego!",13,10,"$"
    salto   db 13,10,"$"


    letra_a db " AAAAA ",13,10
            db "AA   AA",13,10
            db "AAAAAAA",13,10
            db "AA   AA",13,10
            db "AA   AA",13,10,"$"

    letra_e db "EEEEEEE",13,10
            db "EE     ",13,10
            db "EEEEE  ",13,10
            db "EE     ",13,10
            db "EEEEEEE",13,10,"$"

    letra_i db "IIIIIII",13,10
            db "   II  ",13,10
            db "   II  ",13,10
            db "   II  ",13,10
            db "IIIIIII",13,10,"$"

    letra_o db " OOOOO ",13,10
            db "OO   OO",13,10
            db "OO   OO",13,10
            db "OO   OO",13,10
            db " OOOOO ",13,10,"$"

    letra_u db "UU   UU",13,10
            db "UU   UU",13,10
            db "UU   UU",13,10
            db "UU   UU",13,10
            db " UUUUU ",13,10,"$"
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

;----------------------------------------------------
;PROCEDIMIENTO PARA VERIFICAR SI ES UNA VOCAL
es_vocal PROC
    ;PRIMERO SE VERIFICA SI ES MINUSCULA (ENTRE 'a' Y 'z')
    cmp al, 'a'
    jb  ev_mayus         ;SI ES MENOR QUE 'a', YA ES MAYUSCULA O NO ES LETRA
    cmp al, 'z'
    ja  ev_mayus
    sub al, 20h          ;CONVERTIR DE MINUSCULA A MAYUSCULA

ev_mayus:
    ;AHORA COMPARAR CONTRA LAS 5 VOCALES EN MAYUSCULA
    cmp al, 'A'
    je  ev_si
    cmp al, 'E'
    je  ev_si
    cmp al, 'I'
    je  ev_si
    cmp al, 'O'
    je  ev_si
    cmp al, 'U'
    je  ev_si

    mov al, 0            ;NO ES VOCAL, SE PONE 0 EN AL
    ret

ev_si:
    ret                  ;AL SIGUE CON LA VOCAL EN MAYUSCULA
es_vocal ENDP

;----------------------------------------------------
;PROCEDIMIENTO PARA MOSTRAR LA LETRA GRANDE
mostrar_grande PROC
    push ax

    ;SE COMPARA AL CONTRA CADA VOCAL Y SE IMPRIME LA QUE CORRESPONDE
    cmp al, 'A'
    je  mg_a
    cmp al, 'E'
    je  mg_e
    cmp al, 'I'
    je  mg_i
    cmp al, 'O'
    je  mg_o
    cmp al, 'U'
    je  mg_u
    jmp mg_fin

mg_a: 
    print salto
    print letra_a
    jmp mg_fin
mg_e: 
    print salto
    print letra_e
    jmp mg_fin
mg_i:
    print salto
    print letra_i
    jmp mg_fin
mg_o: 
    print salto
    print letra_o
    jmp mg_fin
mg_u: 
    print salto
    print letra_u

mg_fin: 
    print salto
    pop ax
    ret
mostrar_grande ENDP

;---------------------------------
;INICIO DEL PROGRAMA
inicio:
    mov ax, DATA
    mov ds, ax

    print instruc

ciclo:
    ;SE LEE LA TECLA SIN ECO PARA QUE NO APAREZCA AL TECLEAR
    mov ah, 08h
    int 21h              ;AL = CODIGO ASCII DE LA TECLA

    ;SI SE PRESIONA ESC (1Bh), SE TERMINA EL PROGRAMA
    cmp al, 1Bh
    je  salir

    ;SE VERIFICA SI ES VOCAL
    call es_vocal

    cmp al, 0
    je  no_vocal         ;SI AL=0, NO ERA VOCAL

    ;SI ES VOCAL, SE MUESTRA LA LETRA GRANDE
    call mostrar_grande
    jmp  ciclo

no_vocal:
    print err      
    jmp  ciclo

salir:
    print adios
    mov ax, 4C00h
    int 21h

CODE ENDS
END inicio