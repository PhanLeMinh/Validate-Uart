class half_rcv_none_parity_test extends uart_base_test;
    `uvm_component_utils(half_rcv_none_parity_test)

    uart_sequence uart_seq;
    uart_configuration cfg;

    function new(string name="half_rcv_none_parity_test",uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        cfg = uart_configuration::type_id::create("uart_cfg");
        if(!cfg.randomize() with {parity == uart_configuration::NONE; direction == uart_configuration::TRANS;})
            `uvm_fatal(get_type_name(),"Failed to randomize uart_configuration")

        lhs_cfg.copy(cfg);
        rhs_cfg.copy(cfg);
        lhs_cfg.direction = uart_configuration::REV;
        `uvm_info(get_type_name(),$sformatf("LHS Config: \n%s",lhs_cfg.sprint()),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("RHS Config: \n%s",rhs_cfg.sprint()),UVM_LOW)
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        `uvm_info(get_type_name(),"Start sequence",UVM_LOW)

        uart_seq = uart_sequence::type_id::create("uart_seq");

        uart_seq.start(env.rhs_agent.sequencer);

        #1ms;

        phase.drop_objection(this);
    endtask
endclass
