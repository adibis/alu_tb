`ifndef ALU_DRIVER__SV
`define ALU_DRIVER__SV

class alu_driver extends uvm_driver#(alu_base_seq_item);
    `uvm_component_utils(alu_driver)

    virtual alu_if m_alu_vif_h;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    // In the build phase, the driver is connected to the virtual interface.
    // The DUT is also connected to the same interface.
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        assert(uvm_config_db#(virtual alu_if)::get
        (.cntxt(this), .inst_name(""), .field_name("alu_if"), .value(m_alu_vif_h)));
    endfunction: build_phase

    task run_phase(uvm_phase phase);
        alu_base_seq_item m_req_h;

        m_alu_vif_h.dataA_i   <= 32'b0;
        m_alu_vif_h.dataB_i   <= 32'b0;
        m_alu_vif_h.ALUCtrl_i <= 3'b0;

        // Generate a reset sequence.
        // FIXME: Move this to the pre-run phase.
        m_alu_vif_h.rst_i     <= 1'b1;
        repeat (2) @(posedge m_alu_vif_h.clk);
        m_alu_vif_h.rst_i     <= 1'b0;
        // Keep receiving the next transaction from the sequence until you run out.
        // Drive each transaction on the interface as per the protocol.

        // In the alu_agent, the seq_item_port of the alu_driver is hooked up to the
        // seq_item_export port on the sequencer (alu_base_seq_item).
        // The alu_driver accepts alu_transactions with the get_next_item function.

        // Sample timing diagram
        //          ___     ___     ___
        // CLK  ___|   |___|   |___|   |___
        //
        // INP  _______########------------
        //
        // OUT  -------------------#####----
        forever begin
            seq_item_port.get_next_item(m_req_h);

            `uvm_info("DRIVER_START:", $sformatf("DATA:: dataA_i: %32x, dataB_i: %32x, ALU_OP: %3b", m_req_h.dataA_i, m_req_h.dataB_i, m_req_h.ALUCtrl_i), UVM_DEBUG)
            @(negedge m_alu_vif_h.clk);
            m_alu_vif_h.dataA_i   = m_req_h.dataA_i;
            m_alu_vif_h.dataB_i   = m_req_h.dataB_i;
            m_alu_vif_h.ALUCtrl_i = m_req_h.ALUCtrl_i;
            @(negedge m_alu_vif_h.clk);
            m_alu_vif_h.dataA_i   = 32'bz;
            m_alu_vif_h.dataB_i   = 32'bz;
            m_alu_vif_h.ALUCtrl_i = 3'bz;
            `uvm_info("DRIVER_DONE:", $sformatf("DATA:: dataA_i: %32x, dataB_i: %32x, ALU_OP: %3b", m_alu_vif_h.dataA_i, m_alu_vif_h.dataB_i, m_alu_vif_h.ALUCtrl_i), UVM_DEBUG)
            `uvm_info("DRIVER_WAIT:", $sformatf("Waiting for %1d cycles", m_req_h.wait_cycles), UVM_DEBUG)
            repeat (m_req_h.wait_cycles) @(negedge m_alu_vif_h.clk);
            seq_item_port.item_done();
        end // forever
    endtask: run_phase
endclass: alu_driver
`endif
