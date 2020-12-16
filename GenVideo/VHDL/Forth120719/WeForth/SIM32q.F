HEX
3E11E79E forth_' KEY  >body forth_@ ram!
3F11E79E forth_' EMIT >body forth_@ ram!

forth_forget h

DECIMAL
: D+ ROT + >R UM+ R> + ;
: DNEGATE NEGATE >R NEGATE DUP IF -1 ELSE 0 THEN R> + ;
: D- DNEGATE D+ ;
: D2/ DUP 2/ >R 1 AND IF 2/ $80000000 OR ELSE 2/ $7FFFFFFF AND THEN R> ;
: D2* 2* >R DUP $80000000 AND IF 2* R> 1 OR ELSE 2* R> THEN ;

$1F CONSTANT LIMIT ( stack depth )
$1FFF CONSTANT RANGE ( program memory size in words )
VARIABLE CLOCK ( slot is in the last 3 bits )
VARIABLE (REGISTER) ( where registers and stacks are )
VARIABLE BREAK

: REGISTER  (REGISTER) @ ;
: FROM  PAD (REGISTER) ! ;
: TO    PAD $600 + (REGISTER) ! ;

: P     REGISTER ;
: I     REGISTER 4 + ;
: I1    REGISTER 8 + ;
: I2    REGISTER 9 + ;
: I3    REGISTER 10 + ;
: I4    REGISTER 11 + ;
: I5    REGISTER 12 + ;
: RP    REGISTER 13 + ;
: SP    REGISTER 14 + ;
: T     REGISTER 16 + ;
: R     REGISTER 24 + ;
: X     REGISTER 32 + ;
: S     REGISTER 56 + ;
: RSTACK  RP C@ LIMIT AND 8 * REGISTER + $100 + ;
: SSTACK  SP C@ LIMIT AND 8 * REGISTER + $200 + ;

: CYCLE TO P FROM P $600 CMOVE 1 CLOCK +! ;

: JUMP  CLOCK @ 7 OR CLOCK ! ;

: RPUSH ( d -- , push d on return stack )
        FROM R 2@ RP C@ 1 + LIMIT AND TO RP C! RSTACK 2! R 2! ;

: RPOPP ( -- d , pop d from return stack )
        FROM R 2@ RSTACK 2@ RP C@ 1 - LIMIT AND TO RP C! R 2! ;

: SPUSH ( d -- , push d on data stack )
        FROM S 2@ SP C@ 1 + LIMIT AND TO SP C! SSTACK 2!
        FROM T 2@ TO S 2!
        TO T 2! ;

: SPOPP ( -- d , pop d from data stack )
        FROM T 2@
        FROM S 2@ TO T 2!
        FROM SSTACK 2@ SP C@ 1 - LIMIT AND TO SP C! S 2! ;

: continue
        FROM P @ DUP 1+ TO RANGE AND P !
        ram@ DUP I !
        64 /MOD SWAP I5 C!
        64 /MOD SWAP I4 C!
        64 /MOD SWAP I3 C!
        64 /MOD SWAP I2 C!
        63 AND I1 C!
        ;

: nop   JUMP ;
: ei    ;
: di    ;
: bra   I @ TO RANGE AND P ! JUMP ;
: ret   RPOPP DROP TO RANGE AND P !
        JUMP ;
: bn    SPOPP DROP 0< ( branch on sign )
        IF bra ELSE JUMP THEN ;
: bc    SPOPP SWAP DROP ( branch on carry )
        IF bra ELSE JUMP THEN ;
: bz    SPOPP DROP ( branch on zero )
        IF JUMP ELSE bra THEN ;
: call  FROM P @ 0 RPUSH bra ;
: next  FROM R 2@ DROP
        IF ELSE RPOPP 2DROP JUMP EXIT THEN ( exit loop )
        FROM R 2@ DROP 1- 0 TO R 2! ( decrement R )
        FROM bra ;
: times FROM R 2@ DROP
        IF ELSE JUMP EXIT THEN ( exit loop )
        R 2@ 1 0 D- TO R 2! ( decrement R )
        FROM -1 P +! TO -1 P +! ;
: pushr SPOPP RPUSH ;
: dupr  FROM R 2@ SPUSH ;
: popr  RPOPP SPUSH ;
: andd  SPOPP DROP TO T 2@ DROP AND 0 T 2! ;
: xorr  SPOPP DROP TO T 2@ DROP XOR 0 T 2! ;
: com   FROM T 2@ DROP -1 XOR 0 TO T 2! ;
: add   SPOPP DROP 0 TO T 2@ DROP 0 D+ TO 1 AND T 2! ;
: mul   FROM X 2@ DROP 1 AND
        IF S 2@ T 2@ D+
        ELSE T 2@ THEN 1 AND
        2DUP D2/ TO T 2!
        DROP 1 AND >R
        FROM X 2@ DROP 2/ $7FFFFFFF AND R> IF $80000000 OR THEN TO 0 X 2! ;
: div   FROM S 2@ DROP 0 T 2@ DROP 0 D+
        1 AND DUP >R DUP
        IF ELSE 2DROP T 2@ THEN
        D2* ( diff) 1 AND X 2@ DROP $80000000 AND IF 1 0 D+ THEN TO T 2!
        FROM X 2@ DROP 2* R> IF 1+ THEN TO 0 X 2! ;
: shr   FROM T 2@ DROP 2/ 1 TO T 2! ;
: shl   FROM T 2@ D2* 1 AND TO T 2! ;
: rr8   FROM T 2@ DROP DUP 7 FOR D2/ NEXT DROP 0 TO T 2! ;
: ldi   FROM P @ 1+ TO RANGE AND P !
        FROM P @ RANGE AND ram@ 0 SPUSH ;
: pushs FROM T 2@ SPUSH ;
: xt    FROM X 2@ SPUSH ;
: pops  SPOPP 2DROP ;
: overr FROM S 2@ SPUSH ;
: tx    SPOPP TO X 2! ;
: ldx   FROM X 2@ DROP RANGE AND ram@ 0 SPUSH ;
: ldxp  ldx
        FROM X 2@ 1 0 D+ 1 AND TO X 2! ;
: ldrp  FROM R 2@ DROP RANGE AND ram@ 0 SPUSH
        FROM R 2@ 1 0 D+ 1 AND TO R 2! ;
: stx   SPOPP DROP FROM X 2@ DROP RANGE AND ram! ;
: stxp  stx
        FROM X 2@ 1 0 D+ 1 AND TO X 2! ;
: strp  SPOPP DROP FROM R 2@ DROP RANGE AND ram!
        FROM R 2@ 1 0 D+ 1 AND TO R 2! ;
: get   KEY DUP $1B = ABORT" done"
        0 SPUSH ret ;
: put   SPOPP DROP $7F AND EMIT ret ;

HEX

: execute ( code -- )
        DUP 00 = IF DROP bra   EXIT THEN
        DUP 01 = IF DROP ret   EXIT THEN
        DUP 02 = IF DROP bz    EXIT THEN
        DUP 03 = IF DROP bc    EXIT THEN
        DUP 04 = IF DROP call  EXIT THEN
        DUP 05 = IF DROP next  EXIT THEN
        DUP 06 = IF DROP times EXIT THEN
\        DUP 07 = IF DROP di    EXIT THEN
        DUP 08 = IF DROP ldrp  EXIT THEN
        DUP 09 = IF DROP ldxp  EXIT THEN
        DUP 0A = IF DROP ldi   EXIT THEN
        DUP 0B = IF DROP ldx   EXIT THEN
        DUP 0C = IF DROP strp  EXIT THEN
        DUP 0D = IF DROP stxp  EXIT THEN
        DUP 0E = IF DROP rr8   EXIT THEN
        DUP 0F = IF DROP stx   EXIT THEN
        DUP 10 = IF DROP com   EXIT THEN
        DUP 11 = IF DROP shl   EXIT THEN
        DUP 12 = IF DROP shr   EXIT THEN
        DUP 13 = IF DROP mul   EXIT THEN
        DUP 14 = IF DROP xorr  EXIT THEN
        DUP 15 = IF DROP andd  EXIT THEN
        DUP 16 = IF DROP div   EXIT THEN
        DUP 17 = IF DROP add   EXIT THEN
        DUP 18 = IF DROP popr  EXIT THEN
        DUP 19 = IF DROP xt    EXIT THEN
        DUP 1A = IF DROP pushs EXIT THEN
        DUP 1B = IF DROP overr EXIT THEN
        DUP 1C = IF DROP pushr EXIT THEN
        DUP 1D = IF DROP tx    EXIT THEN
        DUP 1E = IF DROP nop   EXIT THEN
        DUP 1F = IF DROP pops  EXIT THEN
        DUP 3E = IF DROP get   EXIT THEN
        DUP 3F = IF DROP put   EXIT THEN
        . ABORT" :Illegel instruction" ;

: .stack ( add # ) FOR AFT DUP 2@ DROP U. 8 - THEN NEXT DROP CR ;
: .sstack ." S:" T 2@ IF ." C" THEN U.
        S 2@ DROP U. SSTACK SP C@ .stack ;
: .rstack ." R:" R 2@ DROP U. RSTACK RP C@ .stack ;
: .xstack ." X:" X 2@ DROP U. ;
: .registers ."  P=" P @ . ."  I=" I @ U.
        ."  I1=" I1 C@ . ."  I2=" I2 C@ .
        ."  I3=" I3 C@ . ."  I4=" I4 C@ .
        ."  I5=" I5 C@ . CR ;
: S  CR ." CLOCK=" CLOCK @ . .registers
        .sstack .rstack .xstack ;

: sync  CLOCK @ 7 AND
        DUP 0 = IF continue DROP EXIT THEN
        DUP 1 = IF   I1 C@ execute DROP EXIT
                THEN
        DUP 2 = IF   I2 C@ execute DROP EXIT
                THEN
        DUP 3 = IF   I3 C@ execute DROP EXIT
                THEN
        DUP 4 = IF   I4 C@ execute DROP EXIT
                THEN
        DUP 5 = IF   I5 C@ execute
                THEN
        DROP JUMP ;
: C     sync CYCLE S ;
: reset FROM P $C00 0 FILL 0 CLOCK ! ;
reset

: G     ( addr -- )
        CR ." Press any key to stop." CR
        BREAK !
        BEGIN sync P @ BREAK @ =
              IF CYCLE C EXIT
              ELSE CYCLE
              THEN
              ?KEY
        UNTIL ;
: PUSH  ( n ) pushs TO 0 T 2! ;
: POP   pops ;

: D     P @ 1- four four ;
: M     show ;
: RUN   CR ." Press ESC to stop." CR
        BEGIN C KEY 1B = UNTIL ;
: P     DUP FROM RANGE AND P ! TO RANGE AND P ! ;

: HELP  CR ." eP32 Simulator, copyright eForth Group, 2000"
        CR ." C: execute next cycle"
        CR ." S: show all registers"
        CR ." D: display next 8 words"
        CR ." addr M: display 128 words from addr"
        CR ." addr P: start execution at addr"
        CR ." addr G: run and stop at addr"
        CR ." RUN: execute, one key per cycle"
        CR ;


