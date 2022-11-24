;/**@brief ESTE PROGRAMA MUESTRA LOS BLOQUES QUE FORMAN UN PROGRAMA 
; * EN ENSAMBLADOR, LOS BLOQUES SON:
; * BLOQUE 1. OPCIONES DE CONFIGURACION DEL DSC: OSCILADOR, WATCHDOG,
; *	BROWN OUT RESET, POWER ON RESET Y CODIGO DE PROTECCION
; * BLOQUE 2. EQUIVALENCIAS Y DECLARACIONES GLOBALES
; * BLOQUE 3. ESPACIOS DE MEMORIA: PROGRAMA, DATOS X, DATOS Y, DATOS NEAR
; * BLOQUE 4. CÓDIGO DE APLICACIÓN
; * @device: DSPIC30F4013
; * @oscilLator: FRC, 7.3728MHz
; */
        .equ __30F3013, 1
        .include "p30F3013.inc"
;******************************************************************************
; BITS DE CONFIGURACIÓN
;******************************************************************************
;..............................................................................
;SE DESACTIVA EL CLOCK SWITCHING Y EL FAIL-SAFE CLOCK MONITOR (FSCM) Y SE 
;ACTIVA EL OSCILADOR INTERNO DE 7.3728MHZ(FAST RC) PARA TRABAJAR
;FSCM: PERMITE AL DISPOSITIVO CONTINUAR OPERANDO AUN CUANDO OCURRA UNA FALLA 
;EN EL OSCILADOR. CUANDO OCURRE UNA FALLA EN EL OSCILADOR SE GENERA UNA TRAMPA
;Y SE CAMBIA EL RELOJ AL OSCILADOR FRC  
;..............................................................................
        config __FOSC, CSW_FSCM_OFF & FRC   
;..............................................................................
;SE DESACTIVA EL WATCHDOG
;..............................................................................
        config __FWDT, WDT_OFF 
;..............................................................................
;SE ACTIVA EL POWER ON RESET (POR), BROWN OUT RESET (BOR), POWER UP TIMER (PWRT)
;Y EL MASTER CLEAR (MCLR)
;POR: AL MOMENTO DE ALIMENTAR EL DSPIC OCURRE UN RESET CUANDO EL VOLTAJE DE 
;ALIMENTACIÓN ALCANZA UN VOLTAJE DE UMBRAL (VPOR), EL CUAL ES 1.85V
;BOR: ESTE MODULO GENERA UN RESET CUANDO EL VOLTAJE DE ALIMENTACIÓN DECAE
;POR DEBAJO DE UN CIERTO UMBRAL ESTABLECIDO (2.7V) 
;PWRT: MANTIENE AL DSPIC EN RESET POR UN CIERTO TIEMPO ESTABLECIDO, ESTO AYUDA
;A ASEGURAR QUE EL VOLTAJE DE ALIMENTACIÓN SE HA ESTABILIZADO (16ms) 
;..............................................................................
        config __FBORPOR, PBOR_ON & BORV27 & PWRT_16 & MCLR_EN
;..............................................................................
;SE DESACTIVA EL CÓDIGO DE PROTECCIÓN
;..............................................................................
   	config __FGS, CODE_PROT_OFF & GWRP_OFF      

;******************************************************************************
; SECCIÓN DE DECLARACIÓN DE CONSTANTES CON LA DIRECTIVA .EQU (= DEFINE EN C)
;******************************************************************************
        .equ MUESTRAS, 64         ;NÚMERO DE MUESTRAS

;******************************************************************************
; DECLARACIONES GLOBALES
;******************************************************************************
;..............................................................................
;PROPORCIONA ALCANCE GLOBAL A LA FUNCIÓN _wreg_init, ESTO PERMITE LLAMAR A LA 
;FUNCIÓN DESDE UN OTRO PROGRAMA EN ENSAMBLADOR O EN C COLOCANDO LA DECLARACIÓN
;"EXTERN"
;..............................................................................
        .global _wreg_init     
;..............................................................................
;ETIQUETA DE LA PRIMER LINEA DE CÓDIGO
;..............................................................................
        .global __reset          
;..............................................................................
;DECLARACIÓN DE LA ISR DEL TIMER 1 COMO GLOBAL
;..............................................................................
        .global __T1Interrupt    

;******************************************************************************
;CONSTANTES ALMACENADAS EN EL ESPACIO DE LA MEMORIA DE PROGRAMA
;******************************************************************************
        .section .myconstbuffer, code
;..............................................................................
;ALINEA LA SIGUIENTE PALABRA ALMACENADA EN LA MEMORIA 
;DE PROGRAMA A UNA DIRECCION MULTIPLO DE 2
;..............................................................................
        .palign 2                

ps_coeff:
        .hword   0x0002, 0x0003, 0x0005, 0x000A
;short int ps_coeff[] = {0x0002, 0x0003, 0x0005, 0x000A };	

;******************************************************************************
;VARIABLES NO INICIALIZADAS EN EL ESPACIO X DE LA MEMORIA DE DATOS
;******************************************************************************
         .section .xbss, bss, xmemory

x_input: .space 2*MUESTRAS        ;RESERVANDO ESPACIO (EN BYTES) A LA VARIABLE
;char x_input[128];
;short int x_input[64];
;int x_input[32];
;******************************************************************************
;VARIABLES NO INICIALIZADAS EN EL ESPACIO Y DE LA MEMORIA DE DATOS
;******************************************************************************

          .section .ybss, bss, ymemory

y_input:  .space 2*MUESTRAS       ;RESERVANDO ESPACIO (EN BYTES) A LA VARIABLE
;******************************************************************************
;VARIABLES NO INICIALIZADAS LA MEMORIA DE DATOS CERCANA (NEAR), LOCALIZADA
;EN LOS PRIMEROS 8KB DE RAM
;******************************************************************************
          .section .nbss, bss, near

var1:     .space 2               ;LA VARIABLE VAR1 RESERVA 1 WORD DE ESPACIO
var2:     .space 2
var3:     .space 2
var4:     .space 2
var5:     .space 2
var6:     .space 2
var7:     .space 2
var8:     .space 2
var9:     .space 2
var0:     .space 2

;******************************************************************************
;SECCION DE CODIGO EN LA MEMORIA DE PROGRAMA
;******************************************************************************
.text					;INICIO DE LA SECCION DE CODIGO

__reset:
        MOV	#__SP_init, 	W15	;INICIALIZA EL STACK POINTER

        MOV 	#__SPLIM_init, 	W0     	;INICIALIZA EL REGISTRO STACK POINTER LIMIT 
        MOV 	W0, 		SPLIM

        NOP                       	;UN NOP DESPUES DE LA INICIALIZACION DE SPLIM

        CALL 	_WREG_INIT          	;SE LLAMA A LA RUTINA DE INICIALIZACION DE REGISTROS
                                  	;OPCIONALMENTE USAR RCALL EN LUGAR DE CALL
        CALL    INI_PERIFERICOS
CICLO:
	
	MOV	PORTF,	    W1
	NOP
	LSR	W1,	    #2,		W1  ;W1 = W1 >> 2
	AND	#0X0F,	    W1		    ;W1 = W1 & 0X000F
	
	MOV #0,W2
	mov W2, var0
	MOV #1,W2
	mov W2, var1
	MOV #2,W2
	mov W2, var2
	MOV #3,W2
	mov W2, var3
	MOV #4,W2
	mov W2, var4
	MOV #5,W2
	mov W2, var5
	MOV #6,W2
	mov W2, var6
	MOV #7,W2
	mov W2, var7
	MOV #8,W2
	mov W2, var8
	MOV #9,W2
	mov W2, var9
	
	MOV var0,W3
	CPSNE W1, W3
	GOTO DOS
	NOP
	
	MOV var2,W3
	CPSNE W1, W3
	GOTO UNO
	NOP
	
	MOV var7,W3
	CPSNE W1, W3
	GOTO CERO
	NOP

	MOV var1,W3
	CPSNE W1, W3
	GOTO CERO
	NOP
	
	MOV var3,W3
	CPSNE W1, W3
	GOTO NUEVE
	NOP
	
	MOV var6,W3
	CPSNE W1, W3
	GOTO CERO
	NOP

	MOV var4,W3
	CPSNE W1, W3
	GOTO TRES
	NOP
	
	MOV var8,W3
	CPSNE W1, W3
	GOTO OCHO
	NOP

	MOV var5,W3
	CPSNE W1, W3
	GOTO CUATRO
	NOP

	MOV var9,W3
	CPSNE W1, W3
	GOTO TRES
	NOP

	MOV var9,W3
	CPSGT W1, W3
	NOP
	GOTO ERROR
	NOP
	
	
	;MOV	#0,	W2
	;MOV	#1,	W3
	;MOV	#2,	W4
	;MOV	#3,	W5
	;MOV	#4,	W6
	;MOV	#8,	W7
	;MOV	#9,	W8
	;MOV	#0x000A,	W9
	
	
	;CPSNE	W1,	    W2
	;GOTO CERO
	;NOP
	;CPSNE	W1,	    W3
	;GOTO UNO
	;NOP
	;CPSNE	W1,	    W4
	;GOTO DOS
	;NOP
	;CPSNE	W1,	    W5
	;GOTO TRES
	;NOP
	;CPSNE	W1,	    W6
	;GOTO CUATRO
	;NOP
	;CPSNE	W1,	    W7
	;GOTO OCHO
	;NOP
	;CPSNE	W1,	    W8
	;GOTO NUEVE
	;NOP
	;CPSGT	W1,	    W9
	;GOTO ERROR
	
        GOTO    CICLO     

CERO:
    MOV	    #0X007E,W0
    MOV	    W0,	    PORTB
    NOP
    GOTO CICLO
UNO:
    MOV	    #0X0030,W0
    MOV	    W0,	    PORTB
    NOP
    GOTO CICLO
DOS:
    MOV	    #0X006D,W0
    MOV	    W0,	    PORTB
    NOP
    GOTO CICLO
TRES:
    MOV	    #0X0079,W0
    MOV	    W0,	    PORTB
    NOP
    GOTO CICLO
CUATRO:
    MOV	    #0X0033,W0
    MOV	    W0,	    PORTB
    NOP
    GOTO CICLO
OCHO:
    MOV	    #0X007F,W0
    MOV	    W0,	    PORTB
    NOP
    GOTO CICLO
NUEVE:
    MOV	    #0X0073,W0
    MOV	    W0,	    PORTB
    NOP
    GOTO CICLO
ERROR:
    MOV	    #0X004F,W0
    MOV	    W0,	    PORTB
    NOP
    GOTO CICLO

;/**@brief ESTA RUTINA INICIALIZA LOS PERIFERICOS DEL DSC
; */
INI_PERIFERICOS:
	MOV	#0X0000,    W0
	NOP
	MOV	W0,	    PORTF;PORTF = 0X0000
	NOP
	MOV	W0,	    LATF;LATF = 0X0000
	NOP
	SETM	TRISF		;TRISF = 0XFFFF
	NOP
	MOV	W0,	    PORTB;PORTB = 0X0000
	NOP
	MOV	W0,	    LATB;LATB = 0X0000
	NOP
	MOV	W0,	    TRISB;TRISB = 0X0000
	NOP
	SETM	ADPCFG
	
        RETURN

;/**@brief ESTA RUTINA INICIALIZA LOS REGISTROS Wn A 0X0000
; */
_WREG_INIT:
        CLR 	W0
        MOV 	W0, 				W14
        REPEAT 	#12
        MOV 	W0, 				[++W14]
        CLR 	W14
        RETURN

;/**@brief ISR (INTERRUPT SERVICE ROUTINE) DEL TIMER 1
; * SE USA PUSH.S PARA GUARDAR LOS REGISTROS W0, W1, W2, W3, 
; * C, Z, N Y DC EN LOS REGISTROS SOMBRA
; */
__T1Interrupt:
        PUSH.S 


        BCLR IFS0, #T1IF           ;SE LIMPIA LA BANDERA DE INTERRUPCION DEL TIMER 1

        POP.S

        RETFIE                     ;REGRESO DE LA ISR


.END                               ;TERMINACION DEL CODIGO DE PROGRAMA EN ESTE ARCHIVO










