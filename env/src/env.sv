`ifndef ENV__SV
`define ENV__SV

class alu_env extends uvm_env;

    `uvm_component_utils(alu_env)

    alu_agent m_alu_agent_h;
    scoreboard m_scoreboard_h;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        m_alu_agent_h = alu_agent::type_id::create("m_alu_agent_h", this);
        m_scoreboard_h = scoreboard::type_id::create("m_scoreboard_h", this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        m_alu_agent_h.m_analysis_port_h.connect(m_scoreboard_h.m_alu_fifo_h.analysis_export);
    endfunction: connect_phase

endclass: alu_env
`endif
