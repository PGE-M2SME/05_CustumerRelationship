
HEX
cr .( system variables ) 
: HLD 20 ldi ;         \ scratch
: SPAN 21 ldi ;        \ #chars input by expect
: >IN  22 ldi ;        \ input buffer offset
: #TIB 23 ldi ;        \ #chars in the input buffer
: 'TIB 24 ldi ;        \ tib
: BASE 25 ldi ;       \ number base

cr
: CONTEXT 26 ldi ;    \ first search vocabulary
: CP 27 ldi ;         \ dictionary code pointer
: LAST 28 ldi ;       \ ptr to last name compiled
: 'EVAL 29 ldi ;       \ interpret/compile vector
: 'ABORT 2A ldi ;
: TEXT 30 ldi ;         \ unpack buffer
: tmp 2B ldi ;        \ ptr to converted # string
: cpi 2C ldi ;          \ assembler slot poiner
: cpw 2D ldi ;         \ pointer to word under construction

: etxbuf    80000001 ldi ; 
: etxbempty 80000001 ldi ;
: erxbfull  80000002 ldi ;
: erxbuf    80000003 ldi ;

cr .( macro words ) cr
: DOLIT # ;
: EXIT ret ;
: EXECUTE ( a ) pushr ret anew ;
: ! ( n a -- ) tx stx ;
: @ ( a - n ) tx ldx ;
: R> ( - n ) popr ;
: R@ ( - n ) popr pushs pushr ;
: >R ( n ) pushr ;
: DUP ( n - n n ) pushs ;
: SWAP ( n1 n2 - n2 n1 )
   pushr tx popr xt ;
: DROP ( w w  -- )
   pops ;
: 2DROP ( w w  -- )
   pops pops ;
: + ( w w -- w ) add ;
: NOT ( w -- w ) com ;
: AND and ;
: XOR xor ;
: OVER over ;
: NEGATE ( n -- -n )
   com 1 ldi add ;
: 1- ( a -- a )
   -1 ldi add ;
: 1+ ( a -- a )
   1 ldi add ;
: BL ( -- 32 )
   20 ldi ;
: +! ( n a -- )
   tx ldx add stx
   ;
: - ( w w -- w )
   com add 1 ldi add
   ;
: OR ( n n - n )
   com pushr com
   popr and com ;
: ROT ( w1 w2 w3 -- w2 w3 w1 )
   pushr pushr tx popr
   popr xt ;
: 2DUP ( w1 w2 -- w1 w2 w1 w2 )
   pushs pushr pushr
   pushs tx popr xt popr
   ;
: 2! ( d a -- )
   tx pushr stxp
   popr stx ;
: 2@ ( a -- d )
   tx ldxp ldx ;
: COUNT ( b -- b +n )
   tx ldxp pushr xt
   popr ;

cr .( kernel words ) cr
$100 org

code DOVAR popr ret 
code 0< ( n - f )
   shl ifnc pushs pushs xor ret
   then
   -1 ldi ret
code UM+  ( n n - n carry )
   add pushs
   ifnc pushs pushs xor ret
   then
   1 ldi ret
code ?DUP ( w -- w w | 0 )
   pushs
   if pushs ret then
   ret

cr
code DNEGATE ( d -- -d )
   com pushr com 1 ldi
   add pushs
   ifnc popr ret
   then
   popr 1 ldi add ret
code ABS ( n -- +n )
   pushs shl
   ifnc ret then
   NEGATE ret

cr
code = ( w w -- t )
   xor
   if pushs pushs xor ret then
   -1 ldi ret

cr ( pack b> and unpack >b strings )
code B> ( b a -- b+1 a )
   pushr tx ldxp pushr
   xt popr popr tx
   $FF ldi and
   ldx $FFFFFF00 ldi and xor
   rr8 stx xt ret
code >B ( a b -- a+1 b+4 count )
   pushr tx ldxp pushr
   xt popr popr ( a+1 n b ) tx 
   pushs $FF ldi and stxp rr8
   pushs $FF ldi and stxp rr8
   pushs $FF ldi and stxp rr8
   pushs $FF ldi and stxp rr8
   pushr xt popr $FF ldi and
   ret


