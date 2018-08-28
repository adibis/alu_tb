`ifndef ALU_MONITOR__SV
`define ALU_MONITOR__SV

class alu_monitor extends uvm_monitor;
    `uvm_component_utils(alu_monitor)

    virtual alu_if m_alu_vif_h;
    uvm_analysis_port #(alu_base_seq_item) m_analysis_port_h;

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_analysis_port_h = new("m_analysis_port_h", this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        assert(uvm_config_db#(virtual alu_if)::get
        (.cntxt(this), .inst_name(""), .field_name("alu_if"), .value(m_alu_vif_h)));
    endfunction: connect_phase

    task run_phase(uvm_phase phase);
        alu_base_seq_item m_req_h = alu_base_seq_item::type_id::create("monitor_m_req_h");
        alu_base_seq_item m_req_clone_h;
        @(negedge m_alu_vif_h.rst_i);
        forever begin
            @(posedge m_alu_vif_h.clk);
            m_req_h.dataA_i  = m_alu_vif_h.dataA_i;
            m_req_h.dataB_i  = m_alu_vif_h.dataB_i;
            m_req_h.ALUCtrl_i = m_alu_vif_h.ALUCtrl_i;
            `uvm_info("MONITOR:", $sformatf("DATA:: dataA_i: %32x, dataB_i: %32x, ALU_OP: %3b", m_req_h.dataA_i, m_req_h.dataB_i, m_req_h.ALUCtrl_i), UVM_DEBUG)
            @(posedge m_alu_vif_h.clk);
            m_req_h.ALUResult_o = m_alu_vif_h.ALUResult_o;
            m_req_h.Zero_o = m_alu_vif_h.Zero_o;
            `uvm_info("MONITOR:", $sformatf("RESULT:: ALUResult_o: %32x, Zero_o: %1x", m_req_h.ALUResult_o, m_req_h.Zero_o), UVM_DEBUG)
            $cast(m_req_clone_h, m_req_h.clone());
            m_analysis_port_h.write(m_req_clone_h);
        end // forever
    endtask: run_phase
endclass: alu_monitor
`endif
