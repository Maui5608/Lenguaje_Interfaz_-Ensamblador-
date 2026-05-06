;-------------------------
;DAVID EZEQUIEL CABALLERO GONZALEZ
;-------------------------
;LENGUAJE DE INTERFAZ
;------------------------- 
;PROFESOR: MTI. ALEJANDRO SAGUNDO DUARTE 
;-------------------------
;ACTIVIDAD 3.3 ANALISIS DE CODIGO
;-------------------------
;ANALISIS DEL CODIGO CALZADO



pila segment stack
	db 256 dup(?)
pila ends

datos segment
men1	db "BIENVENIDOS A TU PROGRAMA $"
men2	db "ESPERE NO TE APURES EL PROGRAMA ESTA CARGANDO    $"
men3	db "                                              $"
men4	db 13,10,"INGRESE NOMBRES Y APELLIDOS :$"
men5	db 13,10,"INGRESE TU ESTATURA             :$"
men6	db 13,10,"INGRESE TU N° CALZADO              :$"
men7	db 13,10,"INGRESE TU N° TELEFONICO    :$"
men8	db 13,10,"OK.  efectuandose la visualizacion     :$"
men9	db 13,10,"Nombre y Apellidos    :$"
men10	db 13,10,"Suma Estatura-Calzado :$"
men11	db 13,10,"Nro. Telefonico       :$"
men12	db 7,".$"
cap1	db 50,0,49 dup(?),"$"
cap2	db 10,0,9 dup(?),"$"
cap3	db 10,0,9 dup(?),"$"  

cap4	db 11,0,10 dup(?),"$"  ;AQUI SE CAMBIO EL TAMAÑO PARA
                               ;QUE ACEPTE NUMEROS DE 10 DIGITOS
resp	db 6,0,5 dup(?),"$"
datos ends

codigo segment
	assume cs:codigo,ds:datos,ss:pila
inicio:	mov ax,datos
	mov ds,ax

	mov ah,09h
	lea dx,men1
	int 21h

	call retardo

	mov ah,09h
	lea dx,men2
	int 21h

	call retardo1

	mov ah,09h
	lea dx,men4
	int 21h

	mov ah,0ah
	lea dx,cap1
	int 21h

	mov ah,09h
	lea dx,men5
	int 21h

	mov ah,0ah
	lea dx,cap2
	int 21h

	mov ah,09h
	lea dx,men6
	int 21h

	mov ah,0ah
	lea dx,cap3
	int 21h

	mov ah,09h
	lea dx,men7
	int 21h

	mov ah,0ah
	lea dx,cap4
	int 21h

	call retardo

	mov ah,09h
	lea dx,men8
	int 21h

	call retardo1

	mov ah,09h   ;AQUI IMPRIMIMOS MEN9 PARA NOMBRE
	lea dx,men9
	int 21h

	mov bx,2
bucle1:	mov al,cap1[bx]
	mov cl,0dh
	add bx,1
	cmp cl,al
	jne bucle1
	sub bx,1
	mov cap1[bx],24h
	mov bx,2

	mov ah, 09h
	lea dx, cap1[bx]
	int 21h
    
    ;COMO HABIA UNA VARIABLE LLAMADA "men10" QUE NO SE USABA
    ;SE AGREGO UNA NUEVA SECCION PARA ELLO, Y COMO DICE SUMA
    ;PUES HICE UNA SUMA, AUNQUE SOLO DE LOS PRIMEROS DIGITOS
    
    mov ah,09h
	lea dx,men10         ;AQUI SE IMPRIME MEN10
	int 21h

	mov al, cap2[2]      ;OBTENEMOS EL PRIMER DIGITO DE LA ESTATURA
	sub al, 30h          ;RESTAMOS 30H PARA CONVERTIRLOO DE ASCII A NUMERO
	
	mov bl, cap3[2]      ;Y HACEMOS LO MISMO CON EL CALZADO
	sub bl, 30h          
	
	add al, bl           ;HACEMOS UNA SUMA CON LOS PRIMEROS DIGITOS
	add al, 30h          ;SUMAMOS 30H PARA CONVERTIR EL RESULTADO DE VUELTA A ASCCI
	
	mov dl, al           ;MOVEMOS A DL PARA USAR LA FUNCION 02H DE VIDEO
	mov ah, 02h          ;Y SE IMPRIME UN SOLO CARACTER
	int 21h
	mov ah,09h
	
	
	lea dx,men11  ;AQUI SE DEBE IMPRIMIR MEN11 PARA EL TELEFONO
	int 21h

	mov bx,2
bucle2:	mov al,cap4[bx]
	mov cl,0dh
	add bx,1
	cmp cl,al
	jne bucle2
	sub bx,1
	mov cap4[bx],24h
	mov bx,2
	
	mov ah, 09h
	lea dx, cap4[bx]
	int 21h

	jmp fin

retardo:mov cx,1h
l1:	mov dx, 1h       ; SE CAMBIO BX POR DX PARA NO PERDER EL INDICE
a1:	sub dx,1             ; DE LAS CADENAS (BX) AL REGRESAR DEL RETARDO,
	cmp dx,0             ; YA QUE SI DX LLEGA A 0 NO AFECTA A BUCLE1 O BUCLE2.
	jne a1	
	sub cx,1
	cmp cx,0
	jne l1
	ret

retardo1:mov cx,1h
l2:	mov dx,20h           ; SE USA DX PARA PROTEGER EL VALOR DE BX
b1:	sub dx,1             ; Y EVITAR QUE EL INDICE DE CAP1/CAP4 SE BORRE.
	cmp dx,0
	jne b1
	sub cx,1
	;mov ah,09h
	;lea dx,men12
	;int 21h
	cmp cx,0
	jne l2
	ret
	


fin:	mov ah,4ch
	int 21h
codigo ends
	end inicio