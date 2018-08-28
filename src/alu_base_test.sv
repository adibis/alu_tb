`ifndef ALU_BASE_TEST__SV
`define ALU_BASE_TEST__SV

class alu_base_test extends uvm_test;
    `uvm_component_utils(alu_base_test)

    alu_env m_alu_env_h;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_alu_env_h = alu_env::type_id::create(.name("m_alu_env_h"), .parent(this));
    endfunction: build_phase

    task run_phase(uvm_phase phase);
        alu_base_seq m_alu_seq_h;

        // Raise objection so the test will not end. Dropping it will end the test.
        phase.raise_objection(.obj(this));
        m_alu_seq_h = alu_base_seq::type_id::create(.name("m_alu_seq_h"));
        assert(m_alu_seq_h.randomize());
        `uvm_info("alu_base_test",{"\n", m_alu_seq_h.sprint()}, UVM_LOW)

        // Set the generated sequence on the sequencer port of the agent.
        // The driver will pick up a transaction each and driver it.
        m_alu_seq_h.start(m_alu_env_h.m_alu_agent_h.m_sequencer_h);
        #10ns;
        phase.drop_objection(.obj(this));
    endtask: run_phase
endclass: alu_base_test
`endif
