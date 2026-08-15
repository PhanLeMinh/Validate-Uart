class error_parity_bit_test extends uart_base_test;
    `uvm_component_utils(error_parity_bit_test);

    uart_sequence lhs_seq; 

    function new(string name= "error_parity_bit_test",uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        assert(lhs_cfg.randomize() with {parity==uart_configuration::ODD;baud_rate==9600;data_width==6;num_of_stop_bit==1;direction==uart_configuration::TRANS;});
        assert(rhs_cfg.randomize() with {parity==uart_configuration::NONE;baud_rate==9600;data_width==6;num_of_stop_bit==1;direction==uart_configuration::REV;});
        `uvm_info(get_type_name(),$sformatf("LHS Config:\n%s",lhs_cfg.sprint()),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("RHS Config:\n%s",rhs_cfg.sprint()),UVM_LOW)
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        err_catcher.add_error_catcher_msg("Parity bit error");
        err_catcher.add_error_catcher_msg("Stop bit error");
        lhs_seq = uart_sequence::type_id::create("lhs_seq");
        lhs_seq.start(env.lhs_agent.sequencer);
        #1ms;

        phase.drop_objection(this);
    endtask
endclass
