;*************************************************************************************
;************************** AMPLIACIONES REALIZADAS***********************************
;*************************************************************************************
;
; Se han realizado las dos ampliaciones
;
; Para la primera ampliacion se ha procedido a buscar el elemento para ver si ya est� 
; marcado con antelaci�n, si ya est� marcado se elimina del vectorPosEspejosMarcados, 
; copiando los elementos restantes de las posteriores posiciones en el vector a la 
; posicion anterior a la que ocupa. Tambien se decrementa la variable numEspejosMarcados
; para recuperar una posicion del vector para que el usuario tenga la opcion de marcar
; un espejo m�s 


;Para la segunda ampliacion se a procedido a revelar el contador inicial (15 para debug /
;30 para no debug) antes de dejar al usuario introducir una opcion. Para esta ampliacion
; se han declarado 6 nuevas variables que son: 
;
;	
;	- INIYLMSJ (fila para imprimir msjLaser )
;	- INIXLMSJ (col para imprimir msjCol)
;	- INIXCONT (fila para los laseres que le faltan al usuario)
;	- INIYCONT (col para los laseres que le faltan al usuario)
;	- msjLaser (mensaje para contador)
;	- numLaser (numero de laseres maximos que puede lanzar el usuario)
;	- numLaseresLanzados (contador de laseres lanzados por el usuario)
;
;Cada vez que el usuario lanza un laser se incrementa el numero de numLaseresLanzados 
;y la diferencia con numLaser se muestra por pantalla utilizando las variables anteriores 
;para que el usuario pueda ver el n� de laseres que le quedan por marcar    
                                                                          
;*************************************************************************************
;************************** AMPLIACIONES REALIZADAS***********************************
;*************************************************************************************

;EQUIVALENCIAS USADAS PARA REPRESENTAR LAS POSICIONES DE LA IMPRESION DE CADENAS EN PANTALLA Y LOS COLORES 

;Posiciones en pantalla para imprimir mensajes para el usuario
INIXMSJ EQU 3
INIYMSJ EQU 23 

;Posiciones en pantalla para pedir al usuario datos de entrada
INIXPEDIR EQU 54
INIYPEDIR EQU 23 

;Posicion en pantalla para imprimir mensaje de laseres restantes
INIXLMSJ EQU 45
INIYLMSJ EQU 0 

;Posicion en pantalla para imprimir el contador del laser restantes
INIXCONT EQU 52
INIYCONT EQU 1

;Posiciones en pantalla para imprimir posLaser
FILLASERARR EQU 2
FILLASERABJ EQU 20
COLLASERIZQ EQU 7
COLLASERDCH EQU 45

;Para escribir en color (fondo frontal)
COLORRESOLVER EQU 0Bh 
COLORMARCAR EQU 9Bh

;Constantes de tablero y espejos
NUMCASILLASJUEGO EQU 64
NUMESPEJOSDEBUG EQU 8 
NUMLASERESDEBUG EQU 15
NUMCOLFILJUEGO EQU 8
NUMTIPOSESPEJOS EQU 4   

;Caracter de marcado de celda
CARACTMARCADO EQU '*'

data segment       
  ;Posicion en MatrizJuego
  filMatrizJuego DB ?  ;0-7
  colMatrizJuego DB ?  ;0-7
  posMatrizJuego DB ?  ;0-63  

  ;Matriz tablero de juego
  matrizJuego DB 64 dup(0)

  ;Para el numero de espejos del juego, las posiciones que ocupan en el tablero y su tipo
  vectorPosEspejos DB 2, 13, 16, 30, 41, 43, 53, 63, 12 dup(0)
  vectorTiposEspejos DB 1, 4, 2, 3, 2, 4, 2, 4, 12 dup(0)  
  numEspejos DB 20   
  numLaser DB 30
  
  ;Para los espejos que el usuario marca como existentes  
  vectorPosEspejosMarcados DB 20 dup (0)
  numEspejosMarcados DB 0 
  
  ;Para el numero de laseres restantes
  numLaseresLanzados DB 0

  ;Posicion desde la que se dispara el laser
  posLaser DB ?
  direcDisparoLaser DB ?  ;0:arriba
                          ;1:derecha
                          ;2:abajo
                          ;3:izquierda

  ;Para calcular trayectoria
  posSalidaLaser DB ?                       
  cambioTrayTipo1 DB 0, 3, 2, 1
  cambioTrayTipo2 DB 1, 0, 3, 2
  cambioTrayTipo3 DB 2, 1, 0, 3
  cambioTrayTipo4 DB 3, 2, 1, 0   

  ;Para imprimir la la MatrizJuego al resolver
  caractImprimirMatrizJuego DB ' '  ; espacioEnBlanco
                            DB '�'  ; espejoTipo1 
                            DB '/'  ; espejoTipo2
                            DB '�'  ; espejoTipo3 
                            DB '\'  ; espejoTipo4 

  ;Para el PROC colocarCursor
  fila    DB ?
  colum   DB ?

  ;Para la E de texto por parte del usuario
  cadenaE DB 7 dup (0)    
                                                     
  tablero DB "F,C         1   2   3   4   5   6   7   8              �������������Ŀ", 10, 13
          DB "            L1  L2  L3  L4  L5  L6  L7  L8             �             �", 10, 13
          DB "          �   �   �   �   �   �   �   �   �            �  LASER1-32  �", 10, 13
          DB "      �����������������������������������������        �  _          �", 10, 13
          DB "1  L32    �   �   �   �   �   �   �   �   �    L9      ���������������", 10, 13
          DB "      �����������������������������������������", 10, 13
          DB "2  L31    �   �   �   �   �   �   �   �   �    L10     �������������Ŀ", 10, 13
          DB "      �����������������������������������������        �             �", 10, 13
          DB "3  L30    �   �   �   �   �   �   �   �   �    L11     �MARCAR1-8,1-8�", 10, 13
          DB "      �����������������������������������������        �_            �", 10, 13
          DB "4  L29    �   �   �   �   �   �   �   �   �    L12     ���������������", 10, 13
          DB "      �����������������������������������������", 10, 13
          DB "5  L28    �   �   �   �   �   �   �   �   �    L13     �������������Ŀ", 10, 13
          DB "      �����������������������������������������        �             �", 10, 13
          DB "6  L27    �   �   �   �   �   �   �   �   �    L14     �   RESOLVER  �", 10, 13
          DB "      �����������������������������������������        �   _         �", 10, 13
          DB "7  L26    �   �   �   �   �   �   �   �   �    L15     ���������������", 10, 13
          DB "      �����������������������������������������", 10, 13
          DB "8  L25    �   �   �   �   �   �   �   �   �    L16     �������������Ŀ", 10, 13
          DB "      �����������������������������������������        �             �", 10, 13
          DB "          �   �   �   �   �   �   �   �   �            �    SALIR    �", 10, 13
          DB "           L24 L23 L22 L21 L20 L19 L18 L17             �    _        �", 10, 13
          DB "                                                       ���������������$"

  ;Mensajes de Interfaz
  msjDebug DB "Modo debug (con tablero precargado)? (S/N)$"  
  msjOpcion DB "Introduce Mf,c para marcar R S o Lz para disparar: $" 
  msjPerdida DB "Has perdido la partida$"
  msjGanada DB "Enhorabuena! Has ganado la partida$" 
  msjLaser DB "LASERREST$"
   
data ends

stack segment
  DW 128 DUP(0)
stack ends



code segment

;*************************************************************************************                                                                                                                        
;********** Procedimientos utilizados en practicas previas ****************************                                                                                                                        
;*************************************************************************************                                                                                                                        
  
  ;Convierte una cadena de caracteres a un numero entero 
  ;E: DX contiene la direccion de la cadena a convertir (debe apuntar al 1er caracter numerico y terminar en 13 o '$')
  ;S: AX contiene el resultado de la conversion, 0 si hay error o si la cadena a convertir es "0"
  CadenaANumero PROC
    push bx
    push cx
    push dx ; cambia con MUL de 16bits
    push si 
    push di
    
    mov si, dx
    xor ax, ax    
    mov bx, 10  
    
    cmp [si], '-'
    jne BCadNum
    
    mov di, si  ;Ajustes si viene un '-' como primer caracter
    inc si

   BCadNum:
    mov cl, [si]          ;Controles de fin
    cmp cl, 13
    je compruebaNeg
    cmp cl, '$'
    je compruebaNeg
    
    cmp cl, '0'
    jl error
    cmp cl, '9'
    jg error
    
    mul bx
    sub cl, '0'
    xor ch, ch
    add ax, cx
    inc si     
    jmp BCadNum
        
   compruebaNeg:   
    cmp [di], '-'
    jne finCadenaANumero
    neg ax
    jmp finCadenaANumero
   
   error:
    xor ax, ax
   
   finCadenaANumero:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    ret
  CadenaANumero ENDP
                                                                                                                        
  ;Convierte un numero entero a una cadena de caracteres terminada en $
  ;E: AX contiene el numero a convertir
  ;   DX contiene la direccion de la cadena donde almacena la cadena resultado
  NumeroACadena PROC 
    push ax
    push bx
    push cx
    push dx
    push di
    
    mov bx, 10
    mov di, dx
    
    xor cx, cx

    cmp ax, 0  
    jge BNumCad

    mov [di], '-'
    inc di 
    neg ax
    
   BNumCad:        ;Bucle que transforma cada digito a caracter, de menor a mayor peso     
    xor dx, dx
    div bx
    add dl, '0'
    push dx 
    inc cx
    cmp ax, 0
    jne BNumCad

   BInvertir:      ;Bucle para invertir los restos    
    pop [di]
    inc di
    loop BInvertir

    mov [di], '$'

    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
  NumeroACadena ENDP

 
 
  ;F: Imprime una cadena terminada en $ en la posicion donde se encuentre el cursor 
  ;E: DX direccion de comienzo de la cadena a imprimir    
  Imprimir PROC
    push ax

    mov ah,9h
    int 21h

    pop ax
    ret
  Imprimir ENDP 

 
 
  ;F: Imprime un caracter a color en la posicion actual del cursor
  ;E: AL contiene el caracter
  ;   BL el codigo de color a imprimir
  ImprimirCarColor PROC
    push ax
    push bx
    push cx

    mov ah, 9
    xor bh, bh
    mov cx, 1
    int 10h

    pop cx
    pop bx
    pop ax
    ret
  ImprimirCarColor ENDP
 
 

  ;F: Coloca el cursor en una determinada fila y colum de pantalla
  ;E: las variables fila y colum deben contener los valores de posicionamiento
  ColocarCursor PROC
    push ax
    push bx
    push dx

    mov ah, 2
    mov dh, fila
    mov dl, colum
    xor bh, bh
    int 10h

    pop dx
    pop bx
    pop ax
    ret         
  ColocarCursor ENDP                                                                                                   

   
   
  ;Lee una cadena por teclado
  ;E: DX contiene la direccion de la cadena donde se almacenar? la cadena leida                        
  ;E: la posicion 0 de esa cadena debe contener el numero maximo de caracteres a leer
  LeerCadena PROC
    push ax

    mov ah, 0ah
    int 21h

    pop ax
    ret
  LeerCadena ENDP
  
  
;**************************************************************************************
;************************** Nuevos procedimientos que se entregan ***************************
;**************************************************************************************


  ;F: Calcula un valor aleatorio entre 0 y un valor maximo dado-1
  ;E: BL valor maximo 
  ;S: AH valor aleatorio calculado
  NumAleatorio PROC
    push cx
    push dx

    mov ah,2Ch ;interrupcion que recupera la hora actual del sistema operativo
    int 21h
    ;ch=horas cl=minutos dh=segundos dl=centesimas de segundo, 1/100 secs

    xor ah,ah
    mov al,dl  
    div bl
    
    pop dx
    pop cx
    ret
  NumAleatorio ENDP 
               
               
  
  ;F: Lee un caracter por teclado sin eco por pantalla
  ;S: AL caracter ASCII leido
  LeerTeclaSinEco PROC 
    mov ah,8 ;1 para que sea con eco
    int 21h 

    ret  
  LeerTeclaSinEco ENDP   
  
  

  ;F: Oculta el cursor del teclado
  OcultarCursor PROC
    push ax
    push cx

    mov ah,1
    mov ch,20h
    xor cl,cl
    int 10h

    pop cx
    pop ax
    ret
  OcultarCursor ENDP
  
               
               
  ;F: Muestra el cusor del teclado
  MostrarCursor PROC
    push ax
    push cx

    mov ah,1
    mov ch,0Bh
    mov cl,0Ch
    int 10h

    pop cx
    pop ax
    ret
  MostrarCursor ENDP       
  


  ;F: Borra la pantalla (la deja en negro)
  BorrarPantalla PROC
    push ax
    push bx
    push cx
    push dx

    mov ah, 6h
    xor al, al
    mov bh, 7
    xor cx, cx
    mov dh, 24
    mov dl, 79
    int 10h 

    pop dx
    pop cx
    pop bx
    pop ax
    ret
  BorrarPantalla ENDP

              
  ;F: Borra la linea de mensajes completa            
  BorrarLineaMsj PROC  
    push ax
    push bx
    push cx
    push dx

    mov ah, 6h
    xor al, al
    mov bh, 7
    xor cl, cl
    mov ch, INIYMSJ 
    mov dh, INIYMSJ+1
    mov dl, 79
    int 10h 

    pop dx
    pop cx
    pop bx
    pop ax
    ret
  BorrarLineaMsj ENDP    
              
              
  
  ;F: Borra la zona de las cadenas de mensajes que imprimen en pantalla
  BorrarEntradaUsuario PROC
    push ax
    push bx
    push cx
    push dx

    mov ah, 6h
    xor al, al
    mov bh, 7
    mov cl, INIXPEDIR
    mov ch, INIYMSJ 
    mov dh, INIYMSJ+1
    mov dl, INIXPEDIR+4
    int 10h 

    pop dx
    pop cx
    pop bx
    pop ax 
    ret
  BorrarEntradaUsuario ENDP    
  
  
  
  ;F: Limpia el buffer de entrada del teclado por si tuviera algo
;  LimpiarBufferTeclado PROC
;    push ax
;
;    mov ax,0C00h
;    int 21h
;
;    pop ax
;    ret
;  LimpiarBufferTeclado ENDP               
                       
             
;**************************************************************************************
;******************** Procedimientos de Laboratorios***********************************
;**************************************************************************************  
 
 
;----------------------------------------- Sesion 6 -----------------------------------------  
  
;F: Calcula a partir de una fila y una columna de la matriz la posicion en el tablero
;E: NUMCOLFILAJUEGO, filMatrizJuego, colMatrizJuego
;S: posMatrizJuego
MatrizAVector PROC
     
   push ax 
    
    xor ax,ax
    mov al, NUMCOLFILJUEGO    ; mueve al registro al NUMCOLFILJUEGO
    dec filMatrizJuego        ; decrementamos filMatrizJUego
    mul filMatrizJuego        ; multiplica filMatrizJuego por el registro al  
    dec colMatrizJuego        ; decrementamos colMatrizJuego
    add al, colMatrizJuego    ; suma el registro al con colMatrizJuego
    mov posMatrizJuego, al    ; mueve el registro al a posMatrizJuego
    
   pop ax 
    
    ret
    
MatrizAVector ENDP 
  
;F: Calcula a partir de una posicion, la fila y la columna
;E: NUMCOLFILAJUEGO, posMatrizJuego
;S: filMatrizJuego, colMatrizJuego  
VectorAMatriz PROC
    
  push ax
  push dx
  
  xor ax,ax    
  mov al, posMatrizJuego      ; mueve posMatrizJuego al registro 
  mov dx, NUMCOLFILJUEGO      ; mueve a dx NUMCOLFILJUEGO
  div dl                      ; divide al entre dl y lo almacena en ax
  mov filMatrizJuego, al      ; mueve la parte alta de ax (cociente de division) a la variable filmatrizJuego                           
  mov colMatrizJuego, ah      ; mueve la parte baja de ax (resto de division)  a la variable colmatrizJuego
     
  pop dx
  pop ax   
  ret 
VectorAMatriz ENDP      
 
 
;----------------------------------------- Sesion 7 -----------------------------------------  
 
;F: Busca un elemento en el vector.
;E: AH contiene el valor a buscar.
;   SI contiene la direccion de memoria del vector.
;   CX contiene el tamano del vector.
;S: AL tendra valor 1 si ha encontrado el valor y 0 si no lo encuentra 
BusquedaElemento PROC
       
  push si
  push cx 
       
   cmp cx, 0                 ; compara cx con 0 para saber si el vector es nulo 
   je fin                    ; en el caso que sea nulo salta al final 
                             ; del procedimiento
   bucle:
    cmp [si],ah              ; Me compara si el elemento de la posicion si, coincide con el elemento buscado
    je found                 ; si lo encuentra salta a found  
    inc si                   ; incrementa si
   loop bucle                ; salta a la etiqueta bucle y repite el 
      
   mov al,0                  ; pone a 0 ya que no a encontrado el elemento
   jmp fin                   ; salta al final
       
   found:                    ; etiqueta found
   mov al,1                  ; pone a uno si encuentra el elemento
       
   fin:                      ; etiqueta fin
  pop cx
  pop si
ret
BusquedaElemento ENDP 
    
    
;F: Rellena el vector introducido con numeros aleatorios desde 1 a BL (num max).
;E: SI tiene la direccion de memoria del vector.
;   CX tiene el numero de elementos aleatorios         
;   BL numero maximo que puede tomar el numero aleatorio 
;S: Vector relleno de tantos numeros aleatorios como se indique
VectorAleatorio PROC 
  push si
  push cx  
  push ax
        
    cmp cx, 0                    ; compara cx con 0 para saber si el vector introducido es nulo
    je final                     ; llama a la etiqueta final en caso de ser nulo  
                                
    bucleAleatorio:              ; etiqueta de bucle aleatorio
        call NumAleatorio        ; llama al procedimiento NumAleatorio  
        inc ah                   ; incrementa ah
        mov [si], ah             ; mueve ese numero aleatorio al vector 
        inc si                   ; incrementa si 
    loop bucleAleatorio          ; llamada a la etiqueta bucleAleatorio con bucle loop
        
  final:                         ; etiqueta final
 pop ax
 pop cx
 pop si
ret       
VectorAleatorio ENDP          
    

;F: Inserta elementos aleatorios en un vector 
;E: BL el valor maximo-1 que pueden tomar los numeros aleatorios
;   SI la direccion del vector
;   CX tamano del vector
;S: vector relleno con valores [0, bl-1] sin repetir                           
VectorSinRepetir PROC 
 push cx
 push si  
 push ax
 push dx 
 push di
  
   xor ax, ax               ; ponemos ax a 0
   xor dx, dx               ; ponemos dx a 0
   mov di, si               ; copiamos en di, si para guardar la direcion del vector 
   mov bh, cl               ; copiamos en bh, cl para guardar el tama�o del vector
    
   repetir:                  ; etiqueta repetir
   call NumAleatorio         ;llamada al procedimiento NumAleatorio
    mov dl, ah                ; copiamos en dl el numero a insertar 
    
    push si                   ; push si para guardar el vector
    push cx                   ; push cx para guardar el tama�o del vector
     mov cl, bh               ; copiamos en cl, bh (recuperamos tama�o vector)
     mov si, di               ; copiamos en si , di (recuperamos direccion vector)
     call BusquedaElemento    ; llamada al procedimiento BusquedaElemento 
    pop cx                    ; pop cx para recuperar tama�o del vector
    pop si                    ; pop si para recuperar direccion del vector
   
    cmp al, 1                 ; comparamos al con 1 para ver si lo ha encontrado en el vector
    je repetir                ; si el elemento esta, hay que pedir otro numero salto a repetir
   
    mov [si], dl              ; copiamos dl en la 
    inc si                    ; cuando se incrementa aqui, se incrementa para el otro PROC que empieza a comparar en las posiciones no insertadas
   loop repetir              ; loop repetir
       
   pop di
   pop dx
   pop ax
   pop si
   pop cx
ret                          
VectorSinRepetir ENDP  
  

;----------------------------------------- Sesion 8 -----------------------------------------   


;F: Devuelve en BL un numero entre [0,4] segun la opcion introducida por el usuario   
;E: SI contiene la direccion de memoria del vector que contiene la innstruccion
;S: BL la opcion marcada
ValidarOpcion PROC
    
    push ax
    push dx
    push si
    
    cmp [si+2], 'R'              ; compara la posicion con 'R'
    je resolverOpcion            ; salta en caso que sean iguales
    
    cmp [si+2], 'S'              ; compara la posicion con 'S'
    je salirOpcion               ; salta en caso que sean iguales
    
    cmp [si+2], 'L'              ; compara la posicion con 'L'
    je laserOpcion               ; salta en caso que sean iguales   
    
    cmp [si+2], 'M'              ; compara la posicion con 'M'
    jne noValido                 ; salta en caso que sean diferentes
    
    cmp [si+4], ','              ; compara la posicion con ','
    jne noValido                 ; salta en caso que sean diferentes
    
    cmp [si+3], '1'              ; compara la fila con '1'  
    jl noValido                  ; salta en caso de ser mas bajo
    
    cmp [si+3], '8'              ; compara la fila con '8'
    jg noValido                  ; salta en caso de ser mas alto

                      
    cmp [si+5], '1'              ; compara la columna con '1'
    jl noValido                  ; salta en caso de ser mas bajo
    
    cmp [si+5], '8'              ; compara la columna con '8'
    jg noValido                  ; salta en caso de ser mas alto
    
    mov bl, 2h                   ; mueve a bl el 2hs
    
    mov al, [si+3]               ; copiamos el numero en al 
    sub al, '0'                  ; restamos '0' para pasarlo a numero
    mov filMatrizJuego, al       ; copiamos a la variable filMatrizJuego el valor de la fila a marcar    
      
    mov al, [si+5]               ; copiamos el numero en al 
    sub al, '0'                  ; restamos '0' para pasarlo a numero
    mov colMatrizJuego, al       ; copiamos a la variable colMatrizJuego el valor de la fila a marcar  
    jmp final2                   ; salta al final2
    
    laserOpcion:                 ; etiqueta laserOpcion   
      lea dx, [si+3]             ; leemos la direccion del vector para pasarlo a numero
      call CadenaANumero         ; llamada al procedimiento CadenaANumero
            
      cmp ax, 1                  ; comparamos ax con 1
      jl noValido                ; salto a noValido en caso de ser mas bajo que el limite
      cmp ax, 32                 ; comparamos ax con 32
      jg noValido                ; salto a noValido en caso de ser mas alto que el limite 
      
      mov bl, 1h                 ; mueve a bl 1h
      mov posLaser, al           ; copiamos en la variable posLaser el registro al 
      jmp final2                 ; salto a final2
    
    resolverOpcion:              ; etiqueta resolverOpcion
    cmp [si+3],13                ; compara que solo haya el caracter 'R' viendo si al final hay un 13 
    jne noValido                 ; si son distintos salto a noValido
    
    mov bl,3h                    ; mueve a bl 3h
    jmp final2                   ; salta al final2
    
    salirOpcion:                 ; etiqueta salirOpcion
    cmp [si+3],13                ; compara que solo haya el caracter 'S' viendo si al final hay un 13
    jne noValido                 ; si son distintos salto a noValido
    
    mov bl, 4h                   ; mueve a bl 4h
    jmp final2                   ; salto a final2                       
    
    noValido:                    ; etiqueta noValido                     
    mov bl,0h                    ; si accede aqui mueve a bl 0h y quiere decir que la cadena introducida no es valida
    
    final2:                      ; etiqueta final2
    pop si
    pop dx
    pop ax
  ret
ValidarOpcion ENDP  

;----------------------------------------- Sesion 9 -----------------------------------------   

;F: Rellena "matrizJuego" con el tipo indicado por "vectorTiposEspejos", en las posiciones 
;   que indica "vectorPosEspejos"
;E:  SI direccion de comienzo de "matrizJuego"
;    BX direccion de comienzo de "vectorPosEspejos"
;    DI direccion de comienzo de "vectorTiposEspejos"
;    CX tamano los vectores de posicion y tipos de espejos. 
;S: matrizJuego con el tipo de espejos indicado por el vector vectorTiposEspejos,
;   en las posiciones indicadas por el vector vectorPosEspejos
RellenarVector PROC
  
  push ax
  push bx
  push di 
  push si
  
  bucle2:            ; etiqueta bucle
  push bx            ; guarda en la pila en contenido del registro bx
  mov bl, [bx]       ; guarda en bl el contenido de la direccion de memoria de bx
  mov al, [di]       ; guarda en al el contenido de la direccion de memoria de di 
  
  mov [si+bx], al    ; guarda en la direccion de memoria de la direccion si+bx el contenido de al
  pop bx             ; recupera el valor inicial de bx
  inc bx             ; incrementa en uno bx para pasar a la siguiente posicion del vector
  inc di             ; incrementa en uno di para pasar a la siguiente posicion del vector
  
  loop bucle2        ; etiqueta de salto a bucle y decremento de cx (donde se guardaba NUMESPEJOSDEBUG)
    
  pop si
  pop di
  pop bx
  pop ax
    
 ret
RellenarVector ENDP


;F: Establece los parametros de entrada para el procedimiento 'RellenarVector' para luego llamarlo
;E:  
;S: matrizJuego con el tipo de espejos indicado por el vector vectorTiposEspejos,
;   en las posiciones indicadas por el vector vectorPosEspejos 
InicializarMatrizJuegoDebug PROC
  
 push cx
 push bx
 push di
 push si 
  
 
    lea si,matrizJuego              ; guarda en si la direccion de memoria de inicio del vector matrizJuego
    lea bx,vectorPosEspejos         ; guarda en bx la direccion de memoria de inicio del vector vectorPosEspejos
    lea di,vectorTiposEspejos       ; guarda en di la direccion de memoria de inicio del vector vectorTiposEspejos 
    xor cx, cx                      ; ponemos cx a 0
    mov cl, NUMESPEJOSDEBUG         ; guarda en cl la variable NUMESPEJOSDEBUG
    mov numEspejos,cl               ; guarda en numEspejos el registro cl   
    mov numLaser,NUMLASERESDEBUG    ; guarda en numLaser la variable NUMLASERESDEBUG
 
    call RellenarVector             ; llamada al procedimiento RellenarVector
 
 pop si
 pop di
 pop bx
 pop cx   
 ret
InicializarMatrizJuegoDebug ENDP
  
;**************************************************************************************
;******************** Procedimientos de IU ********************************************
;**************************************************************************************  

;F: Modulo principal de juego
;E: 
;S: Salida por que el usuario haya elegido la opcion salir (S) o la opcion resolver (R)
GAME PROC  
    
    push dx
    push si
    push bx 
    push ax  
    
    mov fila, INIYLMSJ              ; copiamos en la variable fila, la variable INIYLMSJ
    mov colum,  INIXLMSJ            ; copiamos en la variable colum, la variable INIXLMSJ
    call ColocarCursor              ; llamada al procedimiento COlocarCursor
    
    lea dx, msjLaser                ; leemos la direccion de comienzo de msjLaser
    call Imprimir                   ; llamada al procedimiento Imprimir
    
    mov fila, INIYCONT              ; copiamos en la variable fila, la variable INIYCONT
    mov colum,  INIXCONT            ; copiamos en la variable colum, la variable INIXCONT
    call ColocarCursor              ; llamada al procedimiento ColocarCursor
   
    xor ax, ax                      ; ponemos ax a 0
    mov al, numLaser                ; copiamos en al la varible numLaser
    lea dx, cadenaE                 ; leemos la direccion de cominezo de cadenaE 
    call NumeroACadena              ; llamada al procedimiento NumeroACadena
    call Imprimir                   ; llamada al procedimiento Imprimir
    
    juego:                          ; etiqueta juego
    
    call BorrarEntradaUsuario       ; llamada al procedimiento BorrarEntradaUsuario 
        
    mov fila, INIYMSJ               ; copiamos en la variable fila el EQU INIYMSJ
    mov colum, INIXMSJ              ; copiamos en la variable colum el EQU INIXMSJ
    call ColocarCursor              ; llamada a el procedimiento ColocarCursor 
     
    lea dx, msjOpcion               ; leemos en dx la direccion de inicio de msjOpcion
    call Imprimir                   ; llamada al procedimiento Imprimir para mostrar msjOpcion
    
    mov fila, INIYPEDIR             ; copiamos en la variable fila el EQU INIYPEDIR
    mov colum, INIXPEDIR            ; copiamos en la variable colum el EQU INIXPEDIR
    call ColocarCursor              ; llamada al procedimiento ColocarCursor 
    
    call MostrarCursor              ; llamada al procedimiento MostrarCursor
    
    mov CadenaE[0], 5               ; copiamos en la posicion 0 de CadenaE un 5 para no dejar al usuario teclear mas de 4 veces
    lea dx, CadenaE                 ; leemos en dx la direccion de inicio de CadenaE
    call LeerCadena                 ; llamada al procedimiento LeerCadena 
    
    lea si, CadenaE                 ; leemos en si la direccion de inicio de CadenaE
    call ValidarOpcion              ; llamada al procedimiento ValidarOpcion
    
    cmp bl, 0                       ; comparamos bl para ver si es incorrecta la cadena introducida 
    je juego                        ; si es incorrecta salto a juego
    call BorrarLineaMsj             ; llamada al procedimiento BorrarLineaMsj
    
    cmp bl, 1                       ; comparamos bl para ver si la cadena introducida corresponde con Lz
    je laser                        ; si es Lz salto a laser
    
    cmp bl, 2                       ; comparamos bl para ver si la cadena introducida corresponde con Mf,c
    je marcar                       ; si es Mf,c salto a marcar
       
    cmp bl, 3                       ; comparamos bl para ver si la cadena introducida corresponde con R
    je resolver                     ; si R salto a reolver
                          
                                    ; si llega aqui cadena introducida corresponde con S
    jmp EndGame                     ; salto a EndGame
   
    laser:                          ; etiqueta laser 
    call OpcionLaser                ; llamada al procedimiento OpcionLaser  
    jmp juego
        
    marcar:                         ; etiqueta marcar                        
    call OpcionMarcar               ; llamada al procedimiento OpcionMarcar
    jmp juego                       ; salto a juego
               
    resolver:                       ; etiqueta resolver                      
    call OpcionResolver             ; llamada al procedimiento OpcionResolver
 
    EndGame:                        ; etiqueta EndGame (fin del juego)  
    pop ax
    pop bx
    pop si
    pop dx 
  ret
 GAME ENDP
;**************************************************************************************
;******************** Procedimientos para la logica del juego *************************
;**************************************************************************************    

;F: Calcula a partir de las variables filMatrizJuego y colMatrizJuego las posiciones en pantalla correspondientes 
;E: filMatrizJuego colMatrizJuego con valor-1 al que se desea calcular 
;    (Ej: M1,2 ) 
;        - filMatrizJuego = 0
;        - colMatrizJuego = 1
;S: fila = 4 + filMatrizJuego x 2
;   colum = 12 + colMatrizJuego x 4                 
MatrizAPantalla PROC  
    
  push ax
  push cx   
    
  mov al, filMatrizJuego                ; copiamos en al la variable filMatrizJuego
  mov cx, 2                             ; copiamos en cx 2 para luego hacer la multiplicacion
  mul cx                                ; hacemos la multiplicacion de cx
  add al, 4                             ; sumamos 4 al resultado de la multiplicacion
  mov fila, al                          ; copiamos en la variable fila el resultado de la operacion
  
  mov al, colMatrizJuego                ; copiamos en al la variable colMatrizJuego
  mov cx, 4                             ; copiamos en cx 4 para luego hacer la multiplicacion
  mul cx                                ; hacemos la multiplicacion de cx
  add al, 12                            ; sumamos 12 al resultado de la multiplicacion
  mov colum, al                         ; copiamos en la variable colum el resultado de la operacion
  
  pop cx
  pop ax 
 ret
MatrizAPantalla ENDP    

;F: Marca la posicion establecida por el usuario al introducir por pantalla Mf,c
;   AMPLIACION: si la posicion estaba marcada de antes, lo desmarca eliminando por pantalla y tambien del vectorPosEspejosMarcados
;E: filMatrizJuego y colMatrizJuego con los valores deseados 
;S: vectorPosEspejosMarcados con la posicion de espejo marcado a�adido y posicion por pantalla la posicion deseada 
;    numEspejos marcados incrementado en el caso de haber marcado la posicion, decrementado en el caso de que se desmarque e igual
;    en el caso de haber alcanzado el maximo de espejos marcados
OpcionMarcar PROC  
    
   push ax
   push bx 
   push cx
   push si 
           
   mov cl, numEspejosMarcados                   ; copiamos en cl la variable numEspejosMarcados
   cmp cl, numEspejos                           ; comparamos numEspejosMarcados con numEspejos, ya que en el caso de ser iguales habriamos llegado al tope para marcar posiciones
   je finMarcar                                 ; si son iguales salto a finMarcar        
           
   call MatrizAVector                           ; llamada al procedimiento MatrizAVector 
   
   xor ax,ax                                    ; ponemos a cero ax
   mov ah, posMatrizJuego                       ; copiamos en ah la variable posMatrizJuego

   cmp cl, ah                                   ; comparamos que el numEspejosMarcados es cero y es igual a la posicion (es la primera vez que se marca y se marca la pos 0)
   je cero                                      ; salto a cero
     
   lea si, vectorPosEspejosMarcados             ; leemos en si la direccion de inicio de vectorPosEspejosMarcados
   xor cx,cx                                    ; ponemos cx a 0
   mov cl, numEspejosMarcados                   ; copiamos en cl la variable numEspejosMarcados
   call BusquedaElemento                        ; llamada al procedimiento BusquedaElemento para ver si la posicion ya est� marcada  
   
   cmp al, 1                                    ; comparamos al con 1 
   je desMarcar                                 ; en caso de ser iguales, la posicion ya estaria marcada salto a desMarcar        

   cero:                                        ; etiqueta cero
    
   xor bx, bx                                   ; ponemos bx a 0
   mov bl, numEspejosMarcados                   ; copiamos en bl numEspejosMarcado para posteriormente usarlo como desplazamiento en el vector vectorPosEspejosMarcados
   mov [si+bx], ah                              ; compiamos en la primera posicion libre, esta viene dada por la variable numEspejosMarcados
   
   inc cl                                       ; incrementamos cl
   mov numEspejosMarcados, cl                   ; copiamos cl a la variable numEspejosMarcados
 
   mov bl, COLORMARCAR                          ; copiamos en bl la variable COLORMARCAR
   jmp imprimirCaracter
    
   desMarcar:                                   ; etiqueta desMarcar
   
   xor bx, bx                                   ; ponemos bx a 0
   xor cx, cx                                   ; ponemos cx a 0
   mov cl, numEspejosMarcados                   ; copiamos en cl la variable numEspejosMarcados
   
   bucleMarcar:                                 ; etiqueta bucleMarcar
    mov al, [si+bx]                             ; copiamos en al el contenido de si+bx
    cmp al, ah                                  ; comparamos si esa posicion es la que queremos eliminar
    je eliminarPos                              ; si es igual salto a eliminarPos
    inc bx                                      ; incrementamos bx (indice)
   loop bucleMarcar                             ; loop bucleMarcar
   
   eliminarPos:                                 ; etiqueta eliminarPos
    inc bx                                      ; incrementamos bx
    mov ah, [si+bx]                             ; copiamos en ah la posicion siguiente del vector al elemento que queremos eliminar
    mov [si+bx-1], ah                           ; copiamos a una posicion anterior el elemento en ah (asi eliminamos elelemento)
   loop eliminarPos                             ; loop eliminarPos
   
   dec numEspejosMarcados                       ; decrementamos la variable numespejosMarcados
                                               
   mov bl, 00h                                  ; copiamos en bl 00h para que borre el caracter (impresion en negro)
   
   imprimirCaracter:                            ; etiqueta finMarcar 
   mov al, CARACTMARCADO                        ; copiamos en al la varaible CARACTMARCADO 
   call MatrizAPantalla                         ; llamada al procedimiento MatrizAPantalla
   call ColocarCursor                           ; llamada al procedimineto ColocarCursor
   call ImprimirCarColor                        ; llamada al procedimiento ImprimirCarColor
   
   finMarcar:
   pop si
   pop cx
   pop bx
   pop ax  
  ret
OpcionMarcar ENDP

;F: Simula al laser saliente desde la posicion establecida por el usuario por Lz
;   AMPLIACION: el n� de laseres que puede disparar el usuario esta limitado (15 debug / 30 no debug)
;E: posLaser con el valor del laser marcado por el usuario 
;S: posicion del laser por pantalla al realizar el recorrido por el tablero, habiendo cambiado la trayectoria o no al pasar por espejos
;    y numLaseresRealizados incrementado por haber lanzado y se muestra por pantalla el n� de laseres que le quedan al usuario (uno menos)
OpcionLaser PROC  
    
 push ax
 push bx
 push cx
 push si
 push di
 push dx 
 
 xor ax, ax                                     ; ponemos ax a 0  
 mov al, numLaser                               ; copiamos en al la variable numLaser
 cmp numLaseresLanzados, al                     ; comparamos numLaseresLanzados con al
 je AcabarLaser                                 ; si son iguales salto a AcabarLaser
 
 mov cadenaE[2], '0'                            ; copiamos en cadenaE[2] el caracter 0 (solo se mostrar� en caso de que el n� de laseres restantes sea < 10)
 lea dx, cadenaE[3]                             ; leemos la direccion de comienzo de cadenaE[3]
 
 mov fila, INIYCONT                             ; copiamos en la variable fila, la variable INIYCONT
 mov  colum, INIXCONT                           ; copiamos en la variabe colum, la variable INIXVCONT
 call ColocarCursor                             ; llamada al procedimiento ColocarCursor
 
 inc numLaseresLanzados                         ; incrementamos numLaseresLanzados
 sub al, numLaseresLanzados                     ; restamos a al la variables numLaseresLanzados   
 call NumeroACadena                             ; llamada al procedimiento NumeroACadena
 
 cmp al, 9                                      ; comparamos al con 9 para saber si al es mas grande que 9
 jg mayorDiez                                   ; si es mas grande salto a mayorDiez       
 lea dx, cadenaE[2]                             ; en el caso de que el numero de laseres restantes sea < 10 tiene que mostrar el 0 que guardamos anteriormente

 mayorDiez:                                     ; etiqueta mayorDiez
 call Imprimir                                  ; llamada al procedimiento Imprimir
                                                    
 xor bx, bx                                     ; ponemos bx a 0
 xor cx, cx                                     ; ponemos cx a 0
  
 cmp posLaser, 8                                ; comparamos si posLaser es menor o igual que 8
 jle laserDown                                  ; si es igual o menor salto a laserDown
 
 cmp posLaser,16                                ; comparamos si posLaser es menor o igual que 16
 jle laserIzq                                   ; si es igual o menor salto a laserIzq
 
 cmp posLaser,24                                ; comparamos si posLaser es menor o igual que 24
 jle laserUp                                    ; si es igual o menor salto a laserUp
    
 mov direcDisparoLaser, 1                       ; si no es ninguno de los casos anteriores posLaser [25-32] copiamos a la variable direcDisparoLaser un uno
 mov al, 32                                     ; copiamos a al un 32 
 sub al, posLaser                               ; restamos 32 - posLaser
 mov filMatrizJuego, al                         ; copiamos el resultado en la variable filMatrizJuego
 mov colMatrizJuego, 0h                         ; copiamos 0h en la variable colMatrizJuego
 jmp bucleLaser                                 ; salto a bucleLaser
 
 laserDown:                                     ; etiqueta laserDown
 mov direcDisparoLaser, 2                       ; copiamos a la variable direcDisparoLaser un dos
 mov filMatrizJuego, 0h                         ; copiamos 0h en la variable filMatrizJuego
 mov al, posLaser                               ; copiamos en al la variable posLaser
 dec al                                         ; decrementamos en uno al
 mov colMatrizJuego, al                         ; copiamos al en la variable colMatrizJuego
 jmp bucleLaser                                 ; salto a bucleLaser
 
 laserIzq:                                      ; etiqueta laserIzq
 mov direcDisparoLaser, 3                       ; copiamos a la variable direcDisparoLaser un tres
 mov al, 9h                                     ; copiamos en al un 8h
 mov bl, posLaser                               ; copiamos en bl la variable posLaser
 sub bl, al                                     ; restamos a el registro bl el registro al
 mov filMatrizJuego, bl                         ; copiamos en la variable filmatrizJuego el registro bl
 mov colMatrizJuego, 7h                         ; copiamos en colMatrizJuego un 8h
 jmp bucleLaser                                 ; salto a bucleLaser
 
 laserUp:                                       ; etiqueta laserUp
 mov direcDisparoLaser, 0                       ; copiamos direcDisparoLaser un cero
 mov filMatrizJuego, 7h                         ; copiamos en filMatrizJuego un 7h
 mov al, 24                                     ; copiamos en al un 24
 sub al, posLaser                               ; restamos 24 - posLaser
 mov colmatrizJuego, al                         ; copiamos el resultado en colMatrizJuego  

  bucleLaser:                                   ; etiqueta bucleLaser
  
  inc colMatrizjuego                            ; incrementamos colMatrizJuego (ajuste programa)
  inc filMatrizJuego                            ; incrementamos filMatrizJuego (ajuste programa)
   
  call MatrizAVector                            ; llamada al porcedimiento MatrizAVector
  lea si, matrizJuego                           ; leemos en si la direccion de comienzo de matrizJuegu

  mov bl, posMatrizJuego                        ; copiamos en bl la variable posMatrizJuego
  cmp [si+bx], 0                                ; comparamos si en esa posicion hay un espejo (!= 0)
  jne espejo                                    ; si hay espejo (!= 0) salto a espejo
  
  avanzar:                                      ; etiqueta avanzar
  
  call VectorAMatriz                            ; llamada al procedimiento VectorAMatriz 
  call MatrizAPantalla                          ; llamada al procedimiento MatrizAPantalla
   
  cmp direcDisparoLaser, 0                      ; comparamos la variable direcDisparoLaser con 0 (arriba)
  je laserArriba                                ; si son iguales salto a laserArriba
 
  cmp direcDisparoLaser, 1                      ; comparamos la variable direcDisparoLaser con 1 (derecha)
  je laserDerch                                 ; si son iguales salto a laserDerch
  
  cmp direcDisparoLaser, 2                      ; comparamos la variable direcDisparoLaser con 2 (abajo)
  je laserAbajo                                 ; si son iguales salto a laserAbajo
                                              
                                                ; si no son ninguna de los anteriores direcDisparoLaser es 4 (izquierda)
    dec colMatrizJuego                          ; decrementamos colMatrizJuego para avanzar
    cmp colMatrizjuego, 0                       ; comparamos colMatrizJuego con 0 para ver si el laser ha salido del tablero
    jl finColIzq                                ; si ha salido (colMatrizJuego < 0) salto a finColIzq
    jmp bucleLaser                              ; salto a bucleLaser
        
  laserArriba:                                  ; etiqueta laserArriba 
    dec filMatrizJuego                          ; decrementamos filMatrizJuego
    cmp filMatrizJuego, 0                       ; comparamos filMatrizJuego con 0 para saber si el laser se a salido del tablero por arriba
    jl finFilaUp                                ; si se a salido (filMatrizJuego < 0) salto a finFilaUp
    jmp bucleLaser                              ; salto a bucleLaser
  
  laserDerch:                                   ; etiqueta laserDerch
    inc colMatrizJuego                          ; incrementamos colMatrizJuego
    cmp colMatrizJuego, 7                       ; comparamos colMatrizJuego con 7 para saber si el laser se a salido del tablero por la derecha
    jg finColDerch                              ; si se a salido (colMatrizJuego > 7) salto a finColDerch
    jmp bucleLaser                              ; salto a bucleLaser
  
  laserAbajo:                                   ; etiqueta laserAbajo
    inc filmatrizJuego                          ; incrementamos filMatrizJuego
    cmp filMatrizJuego, 7                       ; comparamos filMatrizJuego con 7 para saber si el laser se a salido del tablero por abajo
    jg finFilaDown                              ; si se a salido (filMatrizJuego > 7) salto a finFilaDown
    jmp bucleLaser                              ; salto a bucleLaser
    
 espejo:                                        ; etiqueta espejo
 
   mov al, [si+bx]                              ; copiamos en al el contenido de si+bx
   mov bl, direcDisparoLaser                    ; copiamos en bl el contenido de la variable direcDisparoLaser 
   
   cmp al, 1                                    ; comparamos si el espejo es de tipo 1
   je tipo1                                     ; si son iguales salto a tipo1
   
   cmp al, 2                                    ; comparamos si el espejo es de tipo 2
   je tipo2                                     ; si son iguales salto a tipo2
   
   cmp al, 3                                    ; comparamos si el espejo es de tipo 3
   je tipo3                                     ; si son iguales salto a tipo3

     lea di, cambioTrayTipo4                    ; leemos la direccion de comienzo de cambioTrayTipo4 en di
     newTrayectoria:                            ; etiqueta newTrayectoria
     mov bl, [di+bx]                            ; copiamos en bl la nueva trayectoria (di+bx)
     mov direcDisparoLaser, bl                  ; copiamos el registro bl en la variable direcDisparoLaser
     jmp avanzar                                ; salto avanzar
   
   tipo1:                                       ; etiqueta tipo1
     lea di, cambioTrayTipo1                    ; leemos la direccion de comienzo de cambioTrayTipo1 en di
     jmp newTrayectoria                         ; salto a newTrayectoria
    
   tipo2:                                       ; etiqueta tipo2
     lea di, cambioTrayTipo2                    ; leemos la direccion de comienzo de cambioTrayTipo2 en di
     jmp newTrayectoria                         ; salto a newTrayectoria
     
   tipo3:                                       ; etiqueta tipo3
     lea di, cambioTrayTipo3                    ; leemos la direccion de comienzo de cambioTrayTipo3 en di
     jmp newTrayectoria                         ; salto a newTrayectoria
   
   
   finColIzq:                                   ; etiqueta finColIzq
      mov colum, COLLASERIZQ                    ; copiamos COLLASERIZQ a la variable colum 
      jmp finalLaser                            ; salto a finalLaser
      
   finFilaUp:                                   ; etiqueta finFilaUp
      mov fila, FILLASERARR                     ; copiamos FILLASERARR en la variable fila
      jmp finalLaser                            ; salto a finalLaser
      
   finColDerch:                                 ; etiqueta finColDerch
      mov colum, COLLASERDCH                    ; copiamos COLLASERDCH en la variable colum
      jmp finalLaser                            ; salto a finalLaser
     
   finFilaDown:                                 ; etiqueta finFilaDown
      mov fila, FILLASERABJ                     ; copiamos FILLASERABJ en la variable fila

 finalLaser:                                    ; etiqueta finLaser
   call ColocarCursor                           ; llamada al procedimiento ColocarCursor
   xor ax, ax                                   ; ponemos ax a 0
   mov al, posLaser                             ; copiamos la variable posLaser al registro al
   lea dx, cadenaE                              ; leemos la direccion de comienzo del vector cadenaE
   call NumeroACadena                           ; llamada al procedimiento NumeroACadena
   call Imprimir                                ; llamada al procedimiento Imprimir  
   
 AcabarLaser:                                   ; etiqueta AcabarLaser
 pop dx
 pop di
 pop si
 pop cx
 pop bx
 pop ax

 ret
OpcionLaser ENDP 

;F: Resuelve el tablero mostrando en las posiciones donde se encuentran los espejos, diferenciando el tipo de este ultimo
;E:
;S: Tablero resuelto por pantalla con los espejos descubiertos, ademas de mostrar un mensaje para notificarle al usuario si ha ganado o perdido
OpcionResolver PROC 
    
   push si
   push di 
   push dx
   push ax
   push bx
   push cx
    
   lea si, vectorPosEspejos                    ; leemos en si la direccion de inicio de vectorPosEspejos
   lea di, vectorTiposEspejos                  ; leemos en di la direccion de inicio de vectorTiposEspejos
   xor ax, ax                                  ; ponemos ax a 0
   xor bx, bx                                  ; ponemos bx a 0
   xor cx, cx                                  ; ponemos cx a 0
   mov cl, numEspejos                          ; copiamos en cl la variable numEspejos
   
   bucleResolver:  
      mov al, [si+bx]                          ; copiamos en al la posicion del espejo
      mov posMatrizJuego, al                   ; movemos al a la variable posMatrizJuego
      call VectorAMatriz                       ; llamada al porcedimiento VectorAMatriz
      call MatrizAPantalla                     ; llamada al procedimiento MatrizAPantalla
      call ColocarCursor                       ; llamada al procedimiento ColocarCursor
      
      mov al, [di+bx]                          ; movemos el tipo de espejo a al
      
    push di                                    ; push di para guardar la direccion de memoria de di
    push bx                                    ; push bx para guardar el desplazamiento de los vectores
      lea di, caractImprimirMatrizJuego        ; lee la direccion de comienzo del vector caractImprimirMatrizJuego
      mov bl, al                               ; copiamos al en bl
      mov al, [di+bx]                          ; copiamos en al el caracter a imprimir
      mov bl, COLORRESOLVER                    ; copiamos en bl la variable COLORRESOLVER
      call ImprimirCarColor                    ; llamada al procedimineto ImprimirCarColor
    pop bx                                     ; pop bx para recuperar el desplazamiento de los vectores
    pop di                                     ; pop di para recuperar la direccion de memoria de di
      inc bx                                   ; incrementamos bx
   loop bucleResolver                          ; bucle loop bucleResolver
   
   xor cx, cx                                  ; ponemos cx a 0
   mov cl, numEspejos                          ; copiamos cl la variable numEspejos
   cmp numEspejosMarcados, cl                  ; comparamos si se ha llegado al limite de espejos marcados (en caso contrario el jugador ha perdido)
   jl perdido                                  ; si es menor salto a perdido
   
   lea di, vectorPosEspejosMarcados            ; leemos la direccion de comienzo de vectorPosEspejosMarcados
   xor bx, bx                                  ; ponemos bx a 0
  
   recuento:                                   ; etiqueta recuento
   push cx                                     ; push cx para guardar el indice del loop 
      mov cl, numEspejos                       ; copiamos en cl la variable numEspejos
      mov ah, [di+bx]                          ; copiamos en ah el contenido de si+bx
      call BusquedaElemento                    ; llamada al procedimiento BusquedaElemento
   pop cx                                      ; pop cx para recuperar el indice del loop
      cmp al, 0                                ; comparamos si el elemento marcado se encuentra en vectorPosEspejos
      je perdido                               ; si no esta salto a perdido
      inc bx                                   ; incrementamos el indice de busqueda del vector bx
   loop recuento                               ; loop recuento
   
   lea dx, msjGanada                           ; leemos la direccion de inicio de msjGanada en el caso de que todas las posiciones marcadas tengan un espejo
   jmp mensajeFinal                            ; salto a mensajeFinal

   perdido:                                    ; etiqueta perdido
   lea dx, msjPerdida                          ; leemos la direccion de inicio de msjPerdida en el caso de que al menos una posicion marcada no contenga un espejo
   
   mensajeFinal:                               ; etiqueta mensajeFinal
   mov fila,INIYMSJ                            ; copiamos en la variable fila la variable INIYMSJ
   mov colum, INIXMSJ                          ; copiamos en la variable colum la variable INIXMSJ
   call ColocarCursor                          ; llamada al procedimiento ColocarCursor
   call Imprimir                               ; llamada al procedimiento Imprimir
  
  pop cx
  pop bx
  pop ax 
  pop dx
  pop di
  pop si    
 ret
OpcionResolver ENDP

;F: Proc para el modo no debug, inicia el juego en modo no debug rellenando en posiciones aleatorias, espejos de tipos aleatorios.
;E:
;S: vectorPosEspejos lleno de posiciones de espejos alatorios sin repetir
;   vectorTiposEspejos lleno de tipos de espejos
;   matrizJuego con el tipo indicado en vectorTiposEspejos, en las posiciones que indica en vectorPosEspejos
NoModoDebug PROC      
       
   push si
   push di
   push dx
   push cx
   
   xor cx,cx                                   ; ponemos cx a 0
   mov cl, numEspejos                          ; copiamos en cl la variable numEspejos
   
   lea si, vectorPosEspejos                    ; leemos en si la direccion de inicio de vectorPosEspejos
   mov bx, NUMCASILLASJUEGO                    ; copiamos en bx la variable NUMCASILLASJUEGO
   call VectorSinRepetir                       ; llamada al procedimiento VectorSinRepetir
    
   lea si, vectorTiposEspejos                  ; leemos en si la direccion de inicio de vectorTiposEspejos
   mov bx, NUMTIPOSESPEJOS                     ; copiamos en bx la variable NUMTIPOSESPEJOS
   call VectorAleatorio                        ; llamada al proecedimiento VectorAleatorio
     
   lea si, matrizJuego                         ; leemos en si la direccion de inicio de matrizJuego
   lea bx, vectorPosEspejos                    ; leemos en bx la direccion de inicio de vectorPosespejos
   lea di, vectorTiposespejos                  ; leemos en di la direccion de inicio de vectorTiposEspejos    
   call RellenarVector                         ; llamada al proecedimiento RellenarVector 
   
   pop cx
   pop dx
   pop dx
   pop si   
  ret
NoModoDebug ENDP 


;F: Proc para elegir el modo de juego
;E:
;S: Modo de juego ya iniciado 
ElegirModoJuego PROC   
    
  push ax  
    
   pedirCaracter:                        ; etiqueta pedirCaracter
    call OcultarCursor                   ; llamada al procedimiento OcultarCursor
    call LeerTeclaSinEco                 ; llamada al procedimiento LeerTeclaSinEco
   
    cmp al, 'S'                          ; comparamos si el caracter introducido es S
    je debug                             ; si es S salto a debug
  
    cmp al, 'N'                          ; comparamos si el caracter introducido es N
    jne pedirCaracter                    ; si no es N salto a PedirCaracter
       
    call BorrarLineaMsj                  ; llamada al procedimiento BorrarLineaMsj
    call NoModoDebug                     ; llamada al procedimiento NoModoDebug
    jmp gameStart                        ; salto a gameStart
    
    debug:                               ; etiqueta debug
    
    call BorrarLineaMsj                  ; llamada al procedimiento BorrrarLineaMsj
    call InicializarMatrizJuegoDebug     ; llamada al procedimiento InicializarMatrizJuegoDebug
   
    gameStart:                           ; etiqueta gameStart
  pop ax   
 ret
ElegirModoJuego ENDP

;*************************************************************************************
;************************** Programa Principal ***************************************
;*************************************************************************************

       
start:
    mov ax, data
    mov ds, ax
    
    lea dx, tablero        ; leemos en dx la direccion de inicio de tablero
    call Imprimir          ; llamada al procedimiento Imprimir para mostrar el tablero
    
    mov fila, INIYMSJ      ; copiamos en la variable fila el EQU INIYMSJ
    mov colum, INIXMSJ     ; copiamos en la variable colum el EQU INIXMSJ
    call ColocarCursor     ; llamada a el procedimiento ColocarCursor   
        
    lea dx,msjDebug        ; leemos en dx la direccion de inicio de msjDebug
    call Imprimir          ; llamada al procedimiento Imprimir para mostrar msjDebug
    
    call ElegirModoJuego   ; llamada al procedimiento ElegirModoJuego
    call GAME              ; llamada al procedimiento GAME
    
    mov ah, 4ch
    int 21h  
code ends
END Start