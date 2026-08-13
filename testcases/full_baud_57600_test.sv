class full_baud_57600_test extends uart_base_test;
    `uvm_component_utils(full_baud_57600_test)

    uart_sequence lhs_seq;
    uart_sequence rhs_seq;

    function new(string name = "full_baud_57600_test",uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!lhs_cfg.randomize() with {baud_rate==57600;direction == uart_configuration::DUAL;})
            `uvm_fatal(get_type_name(),"Failed to randomize lhs_cfg")
        rhs_cfg.copy(lhs_cfg);
        `uvm_info(get_type_name(),$sformatf("LHS Config:\n%s",lhs_cfg.sprint()),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("RHS Config:\n%s",rhs_cfg.sprint()),UVM_LOW)
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        `uvm_info(get_type_name(),"run_phase: Start sequences",UVM_LOW)

        lhs_seq = uart_sequence::type_id::create("lhs_seq");
        rhs_seq = uart_sequence::type_id::create("rhs_seq");
        fork
            lhs_seq.start(env.lhs_agent.sequencer);
            rhs_seq.start(env.rhs_agent.sequencer);
        join
        #1ms;

        `uvm_info(get_type_name(),"run_phase: Done...",UVM_LOW)

        phase.drop_objection(this);
    endtask

endclass
