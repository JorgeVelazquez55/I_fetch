transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/Documentos/Otros\ archivos/Cicuitos\ y\ Hardware/Verilog/MDE/RISC\ super\ escalar/I_Fetch/Source\ Files {E:/Documentos/Otros archivos/Cicuitos y Hardware/Verilog/MDE/RISC super escalar/I_Fetch/Source Files/I_Fetch.v}
vlog -vlog01compat -work work +incdir+E:/Documentos/Otros\ archivos/Cicuitos\ y\ Hardware/Verilog/MDE/RISC\ super\ escalar/I_Fetch/Source\ Files {E:/Documentos/Otros archivos/Cicuitos y Hardware/Verilog/MDE/RISC super escalar/I_Fetch/Source Files/Single_Port_ROM.v}

vlog -vlog01compat -work work +incdir+E:/Documentos/Otros\ archivos/Cicuitos\ y\ Hardware/Verilog/MDE/RISC\ super\ escalar/I_Fetch/Proyect\ Files/../Source\ Files {E:/Documentos/Otros archivos/Cicuitos y Hardware/Verilog/MDE/RISC super escalar/I_Fetch/Proyect Files/../Source Files/I_Fetch_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  I_Fetch_tb

add wave *
view structure
view signals
run -all
