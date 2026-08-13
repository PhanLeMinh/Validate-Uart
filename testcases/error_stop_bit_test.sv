class error_stop_bit_test extends uart_base_test;
    `uvm_component_utils(error_stop_bit_test);

    uart_sequence lhs_seq; 

    function new(string name= "error_stop_bit_test",uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        lhs_cfg.randomize() with {num_of_stop_bit=1;baud_rate==9600;direction==uart_configuration::TRANS;}
        rhs_cfg.randomize() with {num_of_stop_bit=2;baud_rate==9600;direction==uart_configuration::REV;}
        `uvm_info(get_type_name(),$sformatf("LHS Config:\n%s",lhs_cfg.sprint()),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("RHS Config:\n%s",rhs_cfg.sprint()),UVM_LOW)
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        lhs_seq = uart_sequence::type_id::create("lhs_seq");
        lhs_seq.start(env.lhs_agent.sequencer);
        #1ms;

        phase.drop_objection(this);
    endtask
endclass
