# SingleCycleCPU

Semestral project designing a simple single cycle CPU and implementing it in Verilog. And then running a simple assembly version of sort() that sorts an array of numbers

Original description: "Navrhněte a popište v jazyce Verilog jednoduchý 32-bitový procesor. Procesor musí podporovat následující instrukce: add, sub, and, or, slt, addi, lw, sw, beq, jal, jr, addu.qb a addu_s.qb. Procesor po resetu začne vykonávat instrukce od adresy 0x00000000. Procesor je připojený k instrukční a datové paměti dle obrázku níže."

SrcFiles contains only .v files, CPU contains entire Vivado project

Files tb_cpu.v and data_instr_memory.v were provided by CTU in Prague. 

CPUDiagram contains schematics of the complete CPU. Schematics by Ing. Michal Stepanovsky at CTU Prague

Instructions.jpg and ExtendedInstructions.jpg contain descriptions of assembler instructions the CPU is able to perform.
