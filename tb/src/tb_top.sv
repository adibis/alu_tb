`ifndef TB_TOP__SV
`define TB_TOP__SV

import uvm_pkg::*;
`include "uvm_macros.svh"

module top;

reg clk;

// Interface to connect the ALU agent with the DUT
alu_if    m_alu_if_h (clk);

// DUT connections
alu_top DUT (
    .clk_i(clk),
    .rst_i(m_alu_if_h.rst_i),
    .dataA_i(m_alu_if_h.dataA_i),
    .dataB_i(m_alu_if_h.dataB_i),
    .ALUCtrl_i(m_alu_if_h.ALUCtrl_i),
    .ALUResult_o(m_alu_if_h.ALUResult_o),
    .Zero_o(m_alu_if_h.Zero_o)
);

// Clock generator
initial begin
    clk = 0;
    #5ns;
    forever #5ns clk = !clk;
end

// Set the interface to the DUT to be used by UVM TB.
initial begin
    uvm_config_db#(virtual alu_if)::set(null, "*", "alu_if", m_alu_if_h);
    run_test();
end

endmodule: top
`endif
