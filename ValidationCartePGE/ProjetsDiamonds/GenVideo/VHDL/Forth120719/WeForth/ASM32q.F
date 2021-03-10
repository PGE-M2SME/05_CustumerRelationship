HEX

VARIABLE h
VARIABLE lasth 0 lasth !                  \ init linkfield address lfa

: namer! ( d -- )
   h @ ram!                             \ store double to code buffer
   1 h +!                             \ bump nameh
   ;

: COMPILE-ONLY 40 lasth @ ram@ XOR lasth @ ram! ;
: IMMEDIATE    80 lasth @ ram@ XOR lasth @ ram! ;

VARIABLE hi   VARIABLE hw VARIABLE bi ( for packing)
: align   14 hi ! ;
: org   DUP . CR h !  align ;
: allot ( n -- ) h +! ;

CREATE mask  3F000000 , FC0000 ,  3F000 ,  FC0 ,  3F ,
: #,   ( d ) h @ ram!  1 h +! ;
: ,w   ( d ) hw @ ram@  OR  hw @ ram! ;
: ,i   ( d ) hi @ 14 =  IF  0 hi !  h @ hw !  0 #,  THEN
             hi @ mask + @ AND  ,w  4 hi +! ;
: spread ( n - d ) DUP 40 * DUP 40 * DUP 40 * DUP 40 * + + + + ;
: ,l   ( n ) spread ,i ;
: ,b   ( c ) bi @ 0 = IF 1 bi ! h @ hw ! 0 #, ,w EXIT THEN
             bi @ 1 = IF 2 bi ! 100 * ,w EXIT THEN
             bi @ 2 = IF 3 bi ! 10000 * ,w EXIT THEN
             0 bi ! 1000000 * ,w ;

: inst CONSTANT DOES> R> @ ,i ;
1E spread inst nop

: anew BEGIN hi @ 14 < WHILE nop REPEAT 0 bi ! ;
: # ( d )  0A spread ,i  #, ;
: ldi # ;
: LIT ( d -- ) # ;

: (makehead)
   anew
   20 WORD                                \ get name of new definition
   lasth @ namer!                         \ fill link field of last word
   h @ lasth !                        \ save nfa in lasth
   COUNT DUP ,b                                \ store count
   1- FOR 
      COUNT ,b                              \ fill name field
   NEXT
   DROP anew
   ;

: makehead
   >IN @ >R                               \ save interpreter pointer
   (makehead)
   R> >IN !                               \ restore word pointer
   ;

: $LIT ( -- )
   anew
   22 WORD
   COUNT DUP ,b ( compile count )
   1- FOR 
      COUNT ,b ( compile characters )
   NEXT
   DROP anew ;


: jump CONSTANT DOES> anew R> FFFFFF AND @ OR #, ;
      0 jump bra              0 jump jmp
2000000 jump bz
3000000 jump bc
4000000 jump call
5000000 jump next
5000000 jump NEXT
5000000 jump <NEXT>

: return CONSTANT DOES> R> @ ,i anew ;
 1 spread return ret
 6 spread return times

: begin anew h @ ;
: until bz ;
: untilnc bc ;
: jmp  bra ;

: if      h @ 0 bz ;  ( 5F80000 )
: ifnc    h @ 0 bc ; ( 5F40000 )
: skip    h @ 0 bra ;        ( 5FC0000 )
: then    begin OVER ram@ OR SWAP ram! ;
: else    skip  SWAP then ;
: while   if SWAP ;
: whilenc ifnc  SWAP ;
: repeat  bra then ;
: again   bra ;
: aft ( a -- a' a" )
   DROP skip begin SWAP ;

: BEGIN anew h @ ;
: UNTIL bz ;
: UNTILNC bc ;
: JMP  bra ;

: IF      h @ 0 bz ;  ( 5F80000 )
: IFNC    h @ 0 bc ; ( 5F40000 )
: SKIP    h @ 0 bra ;        ( 5FC0000 )
: THEN    begin OVER ram@ OR SWAP ram! ;
: ELSE    skip  SWAP then ;
: WHILE   if SWAP ;
: WHILENC ifnc  SWAP ;
: REPEAT  bra then ;
: AGAIN   bra ;
: AFT ( a -- a' a" )
   DROP skip begin SWAP ;

: ':   begin  .head CONSTANT  DOES> R> @  call ;
: CODE  makehead ': ;            \ for eforth kernel words
: code  makehead ': ;            \ for eforth kernel words

  08 spread inst ldrp  09 spread inst ldxp ( 0A spread inst ldi) 0B spread inst ldx
  0C spread inst strp  0D spread inst stxp  0E spread inst rr8   0F spread inst stx
  10 spread inst com   11 spread inst shl   12 spread inst shr   13 spread inst mul
  14 spread inst xor   15 spread inst and   16 spread inst div   17 spread inst add
  18 spread inst popr  19 spread inst xt    1A spread inst pushs 1B spread inst over
  1C spread inst pushr 1D spread inst tx  ( 1E spread inst nop ) 1F spread inst pops

: for ( -- a )
   pushr begin ;
: FOR ( -- a )
   pushr begin ;

06 spread inst ei
07 spread inst di



















