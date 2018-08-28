## Details
This is a very simple ALU testbench written using UVM. It's more to understand the concepts of UVM - the idea is to familiarize with a certain directory sructure which can be followed for larger actual DV work and understand the concepts of UVM. It isn't necessarily the best way of doing things, rather a learning tool.

## TODO:
    1. Add a coverage monitor.
    2. Add examples of SVA.
    3. Add more tests.

## Instructions to Run:
setenv ALU_AGENT ~/Git/alu_tb/agents/alu
setenv ALU_ENV ~/Git/alu_tb/env
setenv ALU_TB ~/Git/alu_tb/tb
setenv ALU_TEST ~/Git/alu_tb
setenv ALU_DUT ~/Git/alu_tb/rtl
setenv WORKSPACE ~/Git/alu_tb/WORKSPACE

cd $WORKSPACE

vcs -sverilog -f $ALU_AGENT/src/filelist.f -f $ALU_ENV/src/filelist.f -f $ALU_TB/src/filelist.f -f $ALU_TEST/src/filelist.f -timescale=1ns/10ps -ntb_opts uvm -R +UVM_TESTNAME=alu_base_test
