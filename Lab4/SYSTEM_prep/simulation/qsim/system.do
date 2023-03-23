onerror {quit -f}
vlib work
vlog -work work system.vo
vlog -work work system.vt
vsim -novopt -c -t 1ps -L cycloneiii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.system_vlg_vec_tst
vcd file -direction system.msim.vcd
vcd add -internal system_vlg_vec_tst/*
vcd add -internal system_vlg_vec_tst/i1/*
add wave /*
run -all
