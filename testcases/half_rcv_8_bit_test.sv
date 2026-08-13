class half_rcv_8_bit_test extends uart_base_test;
    `uvm_component_utils(half_rcv_8_bit_test)

    uart_sequence rhs_seq;
    uart_configuration uart_cfg;

    function new(string name = "half_rcv_8_bit_test", uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        uart_cfg = uart_configuration::type_id::create("uart_cfg");

        if(!uart_cfg.randomize() with {data_width == 8; direction == uart_configuration::TRANS;})
            `uvm_fatal(get_type_name(),"Fail to randomize uart_cfg")
        lhs_cfg.copy(uart_cfg);
        rhs_cfg.copy(uart_cfg);
        lhs_cfg.direction = uart_configuration::REV;
        `uvm_info(get_type_name(),$sformatf("LHS Config:\n%s",lhs_cfg.sprint()),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("RHS Config:\n%s",rhs_cfg.sprint()),UVM_LOW)
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        `uvm_info(get_type_name(),"run_phase: Start sequence", UVM_LOW)

        rhs_seq = uart_sequence::type_id::create("lhs_seq");

        rhs_seq.start(env.rhs_agent.sequencer);

        #5ms;

        `uvm_info(get_type_name(),"run_phase: DONE...",UVM_LOW)
        phase.drop_objection(this);
    endtask
endclass
