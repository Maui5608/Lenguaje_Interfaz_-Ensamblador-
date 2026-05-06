;-------------------------
;DAVID EZEQUIEL CABALLERO GONZALEZ
;-------------------------
;LENGUAJE DE INTERFAZ
;------------------------- 
;PROFESOR: MTI. ALEJANDRO SAGUNDO DUARTE 
;-------------------------
;ACTIVIDAD 3.3 ANALISIS DE CODIGO
;-------------------------
;ANALISIS DEL CODIGO RFC

STACK SEGMENT STACK
    DW 64 DUP(?)
STACK ENDS

DATA SEGMENT
    msg1 db "Ingresa tu nombre: $"
    msg2 db 13,10,"Ingresa tu apellido paterno: $"
    msg3 db 13,10,"Ingresa tu apellido materno: $"
    msg4 db 13,10,"Ingresa la fecha (dd/mm/aaaa): $"
    salto db 13,10,"$"

    ; Buffers (formato DOS 0Ah)
    nombre      db 11,0,10 dup('$')
    apellidop   db 11,0,10 dup('$')
    apellidom   db 11,0,10 dup('$')
    fecha       db 12,0,12 dup('$')

    rfc db 10 dup('$')
DATA ENDS

CODE SEGMENT
ASSUME DS:DATA, CS:CODE, SS:STACK

inicio:
    mov ax, DATA
    mov ds, ax

;-------------------------
; MACRO: imprimir
;-------------------------
print MACRO cadena
    mov ah, 09h 
    lea dx, cadena
    int 21h
ENDM                            ;EL ERROR PRINCIPAL FUE QUE
;-------------------------      ;LAS MACROS SE USABAN COMO
; MACRO: leer buffer            ;PROCEDIMIENTOS, LO QUE HACIA
;-------------------------      ;QUE NO FUNCIONARA BIEN EL CODIGO
leer MACRO  buffer
    mov ah, 0Ah
    lea dx, buffer
    int 21h
ENDM
;-------------------------
; NOMBRE
;-------------------------
    ;MACRO print
    print msg1
    
    ;MACRO leer
    leer nombre

    ; Guardar primera letra del nombre
    mov al, [nombre+2]
    call validar_letra
    mov rfc[3], al

;-------------------------
; APELLIDO PATERNO
;-------------------------
    print msg2

    leer apellidop

    ; Primera letra
    mov al, [apellidop+2]
    call validar_letra
    mov rfc[0], al

    ; Primera vocal interna      ;AQUI SE ASEGURO QUE CH  
    mov si, 1                    ;SEA 0 PARA QUE EL CONTADOR 
    mov ch, 0                    ;EN CX SEA EXACTO
    mov cl, [apellidop+1]          
    dec cl
    jz fin_vocal                 ;TAMBIEN SE AGREGO JZ FIN_VOCAL
                                 ;POR SI SOLO HAY UNA LETRA
buscar_vocal:                    ;ESTO CON EL FIN DE EVITAR
    mov al, [apellidop+2+si]     ;UN BUCLE INFINITO

    call es_vocal
    cmp al, 1
    je guardar_vocal

    inc si
    loop buscar_vocal
    jmp fin_vocal

guardar_vocal:
    mov al, [apellidop+2+si]
    mov rfc[1], al

fin_vocal:

;-------------------------
; APELLIDO MATERNO
;-------------------------
    print msg3

    leer apellidom

    mov al, [apellidom+2]
    call validar_letra
    mov rfc[2], al

;-------------------------
; FECHA
;-------------------------
    print msg4

    leer fecha

    ; Año (últimos 2)
    mov al, [fecha+10]            ;OTRO ERROR QUE ME COSTO
    mov rfc[4], al                ;VER, FUE EL ACCESO INCORRECTO
    mov al, [fecha+11]            ;A LA MEMORIA, POR EJEMPLO
    mov rfc[5], al                ;EN FECHA+10 DEBE TENER []
                                  ;YA QUE SIN LOS [] NO OBTIENE
    ; Mes                         ;EL CONTENIDO, SI NO LA DIRECCION
    mov al, [fecha+5]
    mov rfc[6], al                ;TAMBIEN VI QUE ES IMPORTANTE
    mov al, [fecha+6]             ;AL MOMENTO DE ESCRIBIR LA FECHA
    mov rfc[7], al                ;QUE TENGA LOS "/" PORQUE SI NO
                                  ;SALE MAL EL RFC
    ; Día
    mov al, [fecha+2]
    mov rfc[8], al
    mov al, [fecha+3]
    mov rfc[9], al

;-------------------------
; MOSTRAR RFC
;-------------------------
    print salto

    mov cx, 10
    mov si, 0

mostrar:
    mov dl, rfc[si]
    mov ah, 02h
    int 21h
    inc si
    loop mostrar

;-------------------------
; FIN
;-------------------------
    mov ax, 4C00h
    int 21h

;-------------------------
; FUNCIONES AUXILIARES
;-------------------------

; Verifica que no sea número
validar_letra:
    cmp al, '0'
    jb es_letra
    cmp al, '9'
    ja es_letra
    mov al, 'X'   ; reemplazo si es número
es_letra:
    ret

; Detecta vocal
es_vocal:
    cmp al,'a'           ;AQUI SOLO FALTABA VALIDAR LETRAS 
    je vocal             ;MAYUSCULAS, BUENO EXACTAMENTE
    cmp al,'e'           ;VOCALES MAYUSCULAS
    je vocal
    cmp al,'i'
    je vocal
    cmp al,'o'
    je vocal
    cmp al,'u'
    je vocal

    cmp al,'A'
    je vocal
    cmp al,'E'
    je vocal
    cmp al,'I'
    je vocal
    cmp al,'O'
    je vocal
    cmp al,'U'
    je vocal

    mov al,0
    ret

vocal:
    mov al,1
    ret

CODE ENDS
END inicio