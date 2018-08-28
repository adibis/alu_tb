`ifndef ALU_IF__SV
`define ALU_IF__SV

interface alu_if (input bit clk);

    // ALU signals
    logic [31:0] dataA_i, dataB_i, ALUResult_o;
    logic [2:0]  ALUCtrl_i;
    logic rst_i, Zero_o;

endinterface : alu_if

`endif
