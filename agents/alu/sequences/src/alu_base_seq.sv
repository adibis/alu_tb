`ifndef ALU_BASE_SEQ__SV
`define ALU_BASE_SEQ__SV

class alu_base_seq extends uvm_sequence#(alu_base_seq_item);
    `uvm_object_utils(alu_base_seq)

    // Each sequence has a random number of operations.
    // There is a constraint to keep the number reasonable.
    rand int unsigned num_of_ops;
    constraint num_of_ops_con {num_of_ops inside {[16:24]};}

    function new(string name = "alu_base_seq");
        super.new(name);
    endfunction: new

    // This task generates a sequence of transactions.
    task body();
        alu_base_seq_item m_alu_base_seq_item_h;
        repeat (num_of_ops) begin
            m_alu_base_seq_item_h = alu_base_seq_item::type_id::create(.name("m_alu_base_seq_item_h"));
            start_item(m_alu_base_seq_item_h);
            if (!m_alu_base_seq_item_h.randomize()) begin
                `uvm_error("m_alu_base_seq_item_h", "Randomize failed.");
            end
            finish_item(m_alu_base_seq_item_h);
        end
    endtask: body
endclass: alu_base_seq
`endif
