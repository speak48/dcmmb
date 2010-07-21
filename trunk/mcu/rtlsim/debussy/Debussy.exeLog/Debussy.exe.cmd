srcSourceCodeView
debImport "-f" "../debussy/hdl.f" "-2001"
srcResizeWindow 0 0 1160 842
srcViewImportLogFile
debReload
srcHBSelect "mcu_hq_tb" -win $_nTrace1
srcSelect -win $_nTrace1 -range {3 3 3 4 1 1}
debReload
srcHBSelect "mcu_hq_tb" -win $_nTrace1
srcSelect -win $_nTrace1 -range {3 3 3 4 1 1}
srcDeselectAll -win $_nTrace2
debReload
srcHBSelect "mcu_hq_tb" -win $_nTrace1
srcSelect -win $_nTrace1 -range {3 3 3 4 1 1}
srcCloseWindow -win $_nTrace2
srcHBSelect "mcu_hq_tb.mcu_hq_top.pram_if" -win $_nTrace1
srcHBSelect "mcu_hq_tb.mcu_hq_top.program_ram" -win $_nTrace1
srcSetScope -win $_nTrace1 "mcu_hq_tb.mcu_hq_top.program_ram" -delim "."
srcInvokeExtEditor -win $_nTrace1
TDPreferences -snapToTransition on
srcInvokeExtEditor -win $_nTrace1
debReload
srcHBSelect "mcu_hq_tb.mcu_hq_top.program_ram" -win $_nTrace1
srcSelect -win $_nTrace1 -range {40 40 3 4 1 1}
debReload
srcHBSelect "mcu_hq_tb.mcu_hq_top.program_ram" -win $_nTrace1
srcSelect -win $_nTrace1 -range {40 40 3 4 1 1}
debReload
srcHBSelect "mcu_hq_tb.mcu_hq_top.program_ram" -win $_nTrace1
srcSelect -win $_nTrace1 -range {40 40 3 4 1 1}
debReload
srcHBSelect "mcu_hq_tb.mcu_hq_top.program_ram" -win $_nTrace1
srcSelect -win $_nTrace1 -range {40 40 3 4 1 1}
srcDeselectAll -win $_nTrace1
srcHBSelect "mcu_hq_tb.mcu_hq_top.program_ram" -win $_nTrace1
srcHBSelect "mcu_hq_tb.mcu_hq_top.program_ram" -win $_nTrace1
srcSetScope -win $_nTrace1 "mcu_hq_tb.mcu_hq_top.program_ram" -delim "."
srcHBSelect "mcu_hq_tb.mcu_hq_top.program_ram.inst" -win $_nTrace1
srcSetScope -win $_nTrace1 "mcu_hq_tb.mcu_hq_top.program_ram.inst" -delim "."
srcDeselectAll -win $_nTrace1
srcSelect -inst "inst" -win $_nTrace1
srcAction -pos 97 1 1 -win $_nTrace1 -name "inst" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
debReload
srcSelect -win $_nTrace1 -range {98 98 2 3 1 1}
debExit
