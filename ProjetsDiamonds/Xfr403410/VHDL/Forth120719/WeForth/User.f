
( Basic system and common functions )

:: WaitInitDone begin $E0000005 LIT @ 1 LIT = until ;; 

:: EI ei ;;
:: DI di ;;

:: WrMisc1 $E0000026 LIT ! ;; 
:: RdMisc1 $E0000026 LIT @ ;; 
:: WrMisc2 $E0000027 LIT ! ;; 
:: RdMisc2 $E0000027 LIT @ ;; 

:: SetTimer $E0000008 LIT ! ;; 
:: WaitTimer begin $E0000008 LIT @ 0 LIT = until ;; 

:: DlyMs $C350 LIT * SetTimer WaitTimer ;; \ Clk 50MHz

:: o2 OVER OVER ;;
:: d2 DROP DROP ;;

:: RdRnd 0 LIT $E0000012 LIT ! $E0000013 LIT @ ;;
:: SetSeed $E0000011 LIT ! ;;

:: SetTp1 $E0000024 LIT ! ;;
:: SetTp2 $E0000025 LIT ! ;;

( Specific functions )

:: WaitI2cDone begin $E0000035 LIT @ 0 LIT = until ;; 

:: WrI2c $E0000030 LIT ! ;;
:: TrgWrI2c $E0000031 LIT ! WaitI2cDone ;;

( Startup and interrupt )

:: motd
   CR ."| $LIT DVI copy 403 to 410 Forth console by Tachyssema " CR
   HEX
;;

:: UserStartup
   motd
   WaitInitDone

   $BF LIT WrI2c
   8 LIT TrgWrI2c
;;

:: Isr1
   CR ."| $LIT Interruption " CR
;;

