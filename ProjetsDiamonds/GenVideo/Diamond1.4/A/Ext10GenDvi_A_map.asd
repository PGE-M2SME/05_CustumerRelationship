[ActiveSupport MAP]
Device = LFE3-70E;
Package = FPBGA672;
Performance = 8;
LUTS_avail = 66528;
LUTS_used = 3037;
FF_avail = 50276;
FF_used = 999;
INPUT_LVCMOS33 = 2;
OUTPUT_LVCMOS33 = 31;
BIDI_LVCMOS33 = 1;
IO_avail = 380;
IO_used = 34;
Serdes_avail = 2;
Serdes_used = 0;
PLL_avail = 10;
PLL_used = 1;
EBR_avail = 240;
EBR_used = 8;
;
; start of DSP statistics
MULT18X18C = 0;
MULT9X9C = 0;
ALU54A = 0;
ALU24A = 0;
DSP_MULT_avail = 256;
DSP_MULT_used = 0;
DSP_ALU_avail = 128;
DSP_ALU_used = 0;
; end of DSP statistics
;
; Begin EBR Section
Instance_Name = uForth/uForthMem/pmi_ram_dq40961232ndssep32qhnEp1057aae6_0_7_0;
Type = DP16KC;
Width_A = 4;
Depth_A = 4096;
REGMODE_A = NOREG;
REGMODE_B = NOREG;
WRITEMODE_A = NORMAL;
WRITEMODE_B = NORMAL;
GSR = DISABLED;
MEM_INIT_FILE = ep32q.hex;
MEM_LPC_FILE = pmi_ram_dq40961232ndssep32qhnEp1057aae6__PMIS__4096__32__32H;
Instance_Name = uForth/uForthMem/pmi_ram_dq40961232ndssep32qhnEp1057aae6_0_0_7;
Type = DP16KC;
Width_A = 4;
Depth_A = 4096;
REGMODE_A = NOREG;
REGMODE_B = NOREG;
WRITEMODE_A = NORMAL;
WRITEMODE_B = NORMAL;
GSR = DISABLED;
MEM_INIT_FILE = ep32q.hex;
MEM_LPC_FILE = pmi_ram_dq40961232ndssep32qhnEp1057aae6__PMIS__4096__32__32H;
Instance_Name = uForth/uForthMem/pmi_ram_dq40961232ndssep32qhnEp1057aae6_0_1_6;
Type = DP16KC;
Width_A = 4;
Depth_A = 4096;
REGMODE_A = NOREG;
REGMODE_B = NOREG;
WRITEMODE_A = NORMAL;
WRITEMODE_B = NORMAL;
GSR = DISABLED;
MEM_INIT_FILE = ep32q.hex;
MEM_LPC_FILE = pmi_ram_dq40961232ndssep32qhnEp1057aae6__PMIS__4096__32__32H;
Instance_Name = uForth/uForthMem/pmi_ram_dq40961232ndssep32qhnEp1057aae6_0_2_5;
Type = DP16KC;
Width_A = 4;
Depth_A = 4096;
REGMODE_A = NOREG;
REGMODE_B = NOREG;
WRITEMODE_A = NORMAL;
WRITEMODE_B = NORMAL;
GSR = DISABLED;
MEM_INIT_FILE = ep32q.hex;
MEM_LPC_FILE = pmi_ram_dq40961232ndssep32qhnEp1057aae6__PMIS__4096__32__32H;
Instance_Name = uForth/uForthMem/pmi_ram_dq40961232ndssep32qhnEp1057aae6_0_3_4;
Type = DP16KC;
Width_A = 4;
Depth_A = 4096;
REGMODE_A = NOREG;
REGMODE_B = NOREG;
WRITEMODE_A = NORMAL;
WRITEMODE_B = NORMAL;
GSR = DISABLED;
MEM_INIT_FILE = ep32q.hex;
MEM_LPC_FILE = pmi_ram_dq40961232ndssep32qhnEp1057aae6__PMIS__4096__32__32H;
Instance_Name = uForth/uForthMem/pmi_ram_dq40961232ndssep32qhnEp1057aae6_0_4_3;
Type = DP16KC;
Width_A = 4;
Depth_A = 4096;
REGMODE_A = NOREG;
REGMODE_B = NOREG;
WRITEMODE_A = NORMAL;
WRITEMODE_B = NORMAL;
GSR = DISABLED;
MEM_INIT_FILE = ep32q.hex;
MEM_LPC_FILE = pmi_ram_dq40961232ndssep32qhnEp1057aae6__PMIS__4096__32__32H;
Instance_Name = uForth/uForthMem/pmi_ram_dq40961232ndssep32qhnEp1057aae6_0_5_2;
Type = DP16KC;
Width_A = 4;
Depth_A = 4096;
REGMODE_A = NOREG;
REGMODE_B = NOREG;
WRITEMODE_A = NORMAL;
WRITEMODE_B = NORMAL;
GSR = DISABLED;
MEM_INIT_FILE = ep32q.hex;
MEM_LPC_FILE = pmi_ram_dq40961232ndssep32qhnEp1057aae6__PMIS__4096__32__32H;
Instance_Name = uForth/uForthMem/pmi_ram_dq40961232ndssep32qhnEp1057aae6_0_6_1;
Type = DP16KC;
Width_A = 4;
Depth_A = 4096;
REGMODE_A = NOREG;
REGMODE_B = NOREG;
WRITEMODE_A = NORMAL;
WRITEMODE_B = NORMAL;
GSR = DISABLED;
MEM_INIT_FILE = ep32q.hex;
MEM_LPC_FILE = pmi_ram_dq40961232ndssep32qhnEp1057aae6__PMIS__4096__32__32H;
; End EBR Section
; Begin PLL Section
Instance_Name = uPll/PLLInst_0;
Type = EHXPLLF;
Output_Clock(P)_Actual_Frequency = 100.0000;
CLKOP_BYPASS = DISABLED;
CLKOS_BYPASS = DISABLED;
CLKOK_BYPASS = DISABLED;
CLKOK_Input = CLKOP;
FB_MODE = CLKOP;
CLKI_Divider = 5;
CLKFB_Divider = 4;
CLKOP_Divider = 8;
CLKOK_Divider = 2;
Phase_Duty_Control = STATIC;
CLKOS_Phase_Shift_(degree) = 0.0;
CLKOS_Duty_Cycle = 8;
CLKOS_Delay_Adjust_Power_Down = DISABLED;
CLKOS_Delay_Adjust_Static_Delay_(ps) = 0;
CLKOP_Duty_Trim_Polarity = RISING;
CLKOP_Duty_Trim_Polarity_Delay_(ps) = 0;
CLKOS_Duty_Trim_Polarity = RISING;
CLKOS_Duty_Trim_Polarity_Delay_(ps) = 0;
; End PLL Section
