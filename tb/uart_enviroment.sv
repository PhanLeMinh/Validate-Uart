class uart_env extends uvm_env;
    `uvm_component_utils(uart_env)

    virtual uart_if lhs_vif;
    virtual uart_if rhs_vif;

    uart_configuration lhs_cfg;
    uart_configuration rhs_cfg;

    uart_agent lhs_agent;
    uart_agent rhs_agent;

    uart_scoreboard uart_sb;

    function new (string name="uart_enviroment",uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // get uart_if from uvm_test_top
        if(!uvm_config_db#(virtual uart_if)::get(this,"","lhs_vif",lhs_vif))
            `uvm_fatal(get_type_name(),"Fail to get lhs_vif from uvm_config_db")
        if(!uvm_config_db#(virtual uart_if)::get(this,"","rhs_vif",rhs_vif))
            `uvm_fatal(get_type_name(),"Fail to get rhs_vif from uvm_config_db")

        // get uart_cfg from uvm_test_top
        if(!uvm_config_db#(uart_configuration)::get(this,"","lhs_cfg",lhs_cfg))
            `uvm_fatal(get_type_name(),"Fail to get lhs_cfg from uvm_config_db")
        if(!uvm_config_db#(uart_configuration)::get(this,"","rhs_cfg",rhs_cfg))
            `uvm_fatal(get_type_name(),"Fail to get rhs_cfg from uvm_config_db")

        // set uart_if, uart_cfg down to agent
        uvm_config_db#(virtual uart_if)::set(this,"lhs_agent","vif",lhs_vif);
        uvm_config_db#(uart_configuration)::set(this,"lhs_agent","cfg",lhs_cfg);

        uvm_config_db#(virtual uart_if)::set(this,"rhs_agent","vif",rhs_vif);
        uvm_config_db#(uart_configuration)::set(this,"rhs_agent","cfg",rhs_cfg);
        
        // pass config to scoreboard
        uvm_config_db#(uart_configuration)::set(this,"uart_sb","lhs_cfg",lhs_cfg);
        uvm_config_db#(uart_configuration)::set(this,"uart_sb","rhs_cfg",rhs_cfg);
         
        // create component
        lhs_agent = uart_agent::type_id::create("lhs_agent",this);
        rhs_agent = uart_agent::type_id::create("rhs_agent",this);
        uart_sb   = uart_scoreboard::type_id::create("uart_sb",this);

    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        lhs_agent.monitor.monitor_tx.connect(uart_sb.lhs_tx_export);
        lhs_agent.monitor.monitor_rx.connect(uart_sb.lhs_rx_export);
        rhs_agent.monitor.monitor_tx.connect(uart_sb.rhs_tx_export);
        rhs_agent.monitor.monitor_rx.connect(uart_sb.rhs_rx_export);
    endfunction: connect_phase

endclass
