`ifndef ALU_BASE_SEQ_ITEM__SV
`define ALU_BASE_SEQ_ITEM__SV

class alu_base_seq_item extends uvm_sequence_item;

    rand bit [31:0] dataA_i;
    rand bit [31:0] dataB_i;
    randc bit [ 2:0] ALUCtrl_i;
    bit [31:0] ALUResult_o;
    bit        Zero_o;

    rand int wait_cycles;

    `uvm_object_utils_begin(alu_base_seq_item)
        `uvm_field_int(dataA_i, UVM_DEFAULT)
        `uvm_field_int(dataB_i, UVM_DEFAULT)
        `uvm_field_int(ALUCtrl_i, UVM_DEFAULT)
        `uvm_field_int(ALUResult_o, UVM_DEFAULT)
        `uvm_field_int(Zero_o, UVM_DEFAULT)
    `uvm_object_utils_end

    //------------------------------------------
    // Constraints
    //------------------------------------------
    constraint delay_loops {wait_cycles inside {[0:5]};}
    constraint valid_alu_op {ALUCtrl_i inside {3'b000, 3'b001, 3'b010, 3'b011, 3'b100, 3'b110, 3'b111};}

    function new (string name = "alu_base_seq_item");
        super.new(name);
    endfunction: new

endclass: alu_base_seq_item

`endif
