restart -f
mem load -i {C:/Modeltech_pe_edu_10.4a/examples/multicycle/full instructions.mem} -format mti /cpu/MEM/memContent
mem load -filltype value -filldata 00000001 -fillradix hexadecimal /cpu/REGS/registers(8)
mem load -filltype value -filldata 00000001 -fillradix hexadecimal /cpu/REGS/registers(9)
mem load -filltype value -filldata 00000001 -fillradix hexadecimal /cpu/REGS/registers(10)
mem load -filltype value -filldata 00000016 -fillradix hexadecimal /cpu/REGS/registers(12)
mem load -filltype value -filldata 00000005 -fillradix hexadecimal /cpu/REGS/registers(13)
force -freeze sim:/cpu/nextAddr 8'h00 0 -cancel 8
force -freeze sim:/cpu/pCEn 1 0 -cancel 8
force /cpu/clk 0 0, 1 5 -r 10
run 1000