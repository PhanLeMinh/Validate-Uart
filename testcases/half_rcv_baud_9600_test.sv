class half_rcv_baud_9600_test extends uart_base_test;
    `uvm_component_utils(half_rcv_baud_9600_test)
    
    uart_sequence uart_seq;
    uart_configuration uart_cfg;

    function new(string name="half_rcv_baud_9600_test",uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uart_cfg = uart_configuration::type_id::create("uart_cfg");
        if(!uart_cfg.randomize() with {baud_rate==9600;direction==uart_configuration::TRANS;})
            `uvm_fatal(get_type_name(),"Failed to randomize uart_configuration")

        lhs_cfg.copy(uart_cfg);
        rhs_cfg.copy(uart_cfg);
        lhs_cfg.direction = uart_configuration::REV;
        `uvm_info(get_type_name(),$sformatf("LHS Config:\n%s",lhs_cfg.sprint()),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("RHS Config:\n%s",rhs_cfg.sprint()),UVM_LOW)
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        uart_seq = uart_sequence::type_id::create("uart_seq");
        uart_seq.start(env.rhs_agent.sequencer);
        #1ms;
        phase.drop_objection(this);
    endtask
endclass
