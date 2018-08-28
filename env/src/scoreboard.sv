`ifndef SCOREBOARD__SV
`define SCOREBOARD__SV
class scoreboard extends uvm_component;

    `uvm_component_utils(scoreboard)

    uvm_tlm_analysis_fifo #(alu_base_seq_item) m_alu_fifo_h;

    function new(string name = "scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        m_alu_fifo_h = new("m_alu_fifo_h", this);
    endfunction: build_phase

    task run_phase(uvm_phase phase);

        alu_base_seq_item alu_op;
        bit [31:0] expALUResult_o;
        bit        expZero_o;
        forever begin
            m_alu_fifo_h.get(alu_op);
            `uvm_info("SCOREBOARD:", $sformatf("DATA:: alu_op.dataA_i: %32x, alu_op.dataB_i: %32x, ALU_OP: %3b", alu_op.dataA_i, alu_op.dataB_i, alu_op.ALUCtrl_i), UVM_NONE)

            case (alu_op.ALUCtrl_i)
                3'b010: // ADD
                begin
                    expALUResult_o = alu_op.dataA_i + alu_op.dataB_i;
                end

                3'b110: // SUB
                begin
                    expALUResult_o = alu_op.dataA_i - alu_op.dataB_i;
                end

                3'b000: // AND
                begin
                    expALUResult_o = alu_op.dataA_i & alu_op.dataB_i;
                end

                3'b001: // OR
                begin
                    expALUResult_o = alu_op.dataA_i | alu_op.dataB_i;
                end

                3'b011: // XOR
                begin
                    expALUResult_o = alu_op.dataA_i ^ alu_op.dataB_i;
                end

                3'b100: // NOR
                begin
                    expALUResult_o = ~(alu_op.dataA_i | alu_op.dataB_i);
                end

                3'b111: // SLT
                begin
                    if ((alu_op.dataA_i - alu_op.dataB_i) < 0)
                        expALUResult_o = 32'b1;
                    else
                        expALUResult_o = 32'b0;
                end

                default:
                begin
                    expALUResult_o =  32'b0;
                    expZero_o      =   1'b0;
                end
            endcase
            // The zero signal is mainly used by the branch
            if (expALUResult_o == 32'b0) begin
                expZero_o = 1'b1;
            end else begin
                expZero_o = 1'b0;
            end

            `uvm_info("SCOREBOARD:", $sformatf("DATA:: alu_op.ALUResult_o: %32x, expALUResult_o: %32x, alu_op.Zero_o: %1b, expZero_o: %1b", alu_op.ALUResult_o, expALUResult_o, alu_op.Zero_o, expZero_o), UVM_NONE)
            if(alu_op.ALUResult_o == expALUResult_o && alu_op.Zero_o == expZero_o) begin
                `uvm_info("SCOREBOARD:", $sformatf("CHECK_OK"), UVM_NONE)
            end else begin
                `uvm_error("SCOREBOARD:", $sformatf("CHECK_FAILED"))
            end

        end // forever
    endtask: run_phase

endclass: scoreboard
`endif
