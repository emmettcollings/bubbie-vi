

	#ifndef	REGS_68HC908JB8

REGS_68HC908JB8 	.EQU 	1

PTA 	.EQU	$00
PTB 	.EQU 	$01
PTC 	.EQU 	$02
PTD 	.EQU	$03

DDRA 	.EQU	$04
DDRB 	.EQU	$05
DDRC 	.EQU	$06
DDRD 	.EQU	$07


PTE 	.EQU	$0008
DDRE 	.EQU	$0009
TSC 	.EQU	$000a

TCNT	.EQU	$000c
TCNTH 	.EQU	$000c
TCNTL 	.EQU	$000d
TMODH 	.EQU	$000e
TMODL 	.EQU	$000f

TSC0 	.EQU	$0010
TCH0H 	.EQU	$0011
TCH0L 	.EQU	$0012
TSC1 	.EQU	$0013
TCH1H 	.EQU	$0014
TCH1L 	.EQU	$0015

KBSCR 	.EQU	$0016
KBIER 	.EQU	$0017

UIR2 	.EQU $0018
UCR2 	.EQU $0019
UCR3 	.EQU $001a
UCR4 	.EQU $001b
IOCR 	.EQU $001c
POCR 	.EQU $001d
ISCR 	.EQU $001e

CONFIG 	.EQU	$1F

UE0D0 	.EQU $0020
UE0D1 	.EQU $0021
UE0D2 	.EQU $0022
UE0D3 	.EQU $0023
UE0D4 	.EQU $0024
UE0D5 	.EQU $0025
UE0D6 	.EQU $0026
UE0D7 	.EQU $0027
UE1D0 	.EQU $0028
UE1D1 	.EQU $0029
UE1D2 	.EQU $002a
UE1D3 	.EQU $002b
UE1D4 	.EQU $002c
UE1D5 	.EQU $002d
UE1D6 	.EQU $002e
UE1D7 	.EQU $002f
UE2D0 	.EQU $0030
UE2D1 	.EQU $0031
UE2D2 	.EQU $0032
UE2D3 	.EQU $0033
UE2D4 	.EQU $0034
UE2D5 	.EQU $0035
UE2D6 	.EQU $0036
UE2D7 	.EQU $0037
UADDR 	.EQU $0038
UIR0 	.EQU $0039
UIR1 	.EQU $003a
UCR0 	.EQU $003b
UCR1 	.EQU $003c
USR0 	.EQU $003d
USR1 	.EQU $003e


BSR			.EQU	$FE00
RSR			.EQU	$FE01
BFCR		.EQU	$FE03
INT1		.EQU	$FE04
FLCR		.EQU	$FE08
FLBPR		.EQU	$FE09
BRKH		.EQU	$FE0C
BRKL		.EQU	$FE0D
BRKSCR		.EQU	$FE0E

COPCTL		.EQU	$FFFF


_vect_KBIR		.EQU	$FFF0
_vect_TIMOVF	.EQU	$FFF2
_vect_TIM1		.EQU	$FFF4
_vect_TIM0		.EQU	$FFF6
_vect_IRQ		.EQU	$FFF8
_vect_USB		.EQU	$FFFA
_vect_SWI		.EQU	$FFFC
_vect_RESET		.EQU	$FFFE

		#endif


	#include "bits68hc908.asm"
