`ifndef ALU_AGENT__SV
`define ALU_AGENT__SV

class alu_agent extends uvm_agent;
    `uvm_component_utils(alu_agent)

    uvm_analysis_port #(alu_base_seq_item) m_analysis_port_h;
    uvm_sequencer #(alu_base_seq_item)     m_sequencer_h;
    alu_driver                             m_driver_h;
    alu_monitor                            m_monitor_h;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Monitor should always be present.
        m_monitor_h = alu_monitor::type_id::create("m_monitor_h", this);

        // Analysis port should always be present.
        m_analysis_port_h = new("m_analysis_port_h", this);

        // Only build the driver and sequencer if agent is active.
        m_driver_h = alu_driver::type_id::create("m_driver_h", this);
        m_sequencer_h = uvm_sequencer#(alu_base_seq_item)::type_id::create("m_sequencer_h", this);

    endfunction: build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        m_monitor_h.m_analysis_port_h.connect(m_analysis_port_h);

        // Only connect the driver and the sequencer if agent is active.
        m_driver_h.seq_item_port.connect(m_sequencer_h.seq_item_export);
    endfunction: connect_phase
endclass: alu_agent
`endif
