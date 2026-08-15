class uart_base_test extends uvm_test;
    `uvm_component_utils(uart_base_test)

    virtual uart_if lhs_vif;
    virtual uart_if rhs_vif;

    uart_configuration lhs_cfg;
    uart_configuration rhs_cfg;

    uart_env env;
    uart_error_catcher err_catcher;

    function new(string name="uart_base_test", uvm_component parent);
        super.new(name,parent);
    endfunction

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(),"build_phase: Entered...",UVM_HIGH)
        if(!uvm_config_db#(virtual uart_if)::get(this,"","lhs_vif",lhs_vif))
            `uvm_fatal(get_type_name(),"Fail to get lhs_vif from uvm_config_db")
        if(!uvm_config_db#(virtual uart_if)::get(this,"","rhs_vif",rhs_vif))
            `uvm_fatal(get_type_name(),"Fail to get rhs_vif from uvm_config_db")

        lhs_cfg = uart_configuration::type_id::create("lhs_cfg",this);
        rhs_cfg = uart_configuration::type_id::create("rhs_cfg",this);
        if(!lhs_cfg.randomize())
            `uvm_fatal(get_type_name(),"Fail to randomize lhs_cfg")
        if(!rhs_cfg.randomize())
            `uvm_fatal(get_type_name(),"Fail to randomize rhs_cfg")

        env = uart_env::type_id::create("env",this);

        err_catcher = uart_error_catcher::type_id::create("err_catcher");
        uvm_report_cb::add(null,err_catcher);
    
        uvm_config_db#(virtual uart_if)::set(this,"env","lhs_vif",lhs_vif);
        uvm_config_db#(virtual uart_if)::set(this,"env","rhs_vif",rhs_vif);
        uvm_config_db#(uart_configuration)::set(this,"env","lhs_cfg",lhs_cfg);
        uvm_config_db#(uart_configuration)::set(this,"env","rhs_cfg",rhs_cfg);

        `uvm_info(get_type_name(),"build_phase: Exiting...",UVM_HIGH)
    endfunction

    virtual function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "start_of_simulation_phase: Entered...",UVM_HIGH)
        uvm_top.print_topology();
        `uvm_info(get_type_name(), "start_of_simulation_phase: Exiting...",UVM_HIGH)
    endfunction

    virtual function void final_phase(uvm_phase phase);
        uvm_report_server srv;
        super.final_phase(phase);
        `uvm_info("final_phase","Entered...",UVM_HIGH)
        srv = uvm_report_server::get_server();
        if(srv.get_severity_count(UVM_FATAL) + srv.get_severity_count(UVM_ERROR) > 0) begin
            $display("\n\033[31m===========================================================");
            $display("             ##### Status: TEST FAILED #####         ");
            $display("===========================================================\033[0m\n");
        end 
        else begin
            $display("\n\033[32m==========================================================");
            $display("              ##### Status: TEST PASSED #####          ");
            $display("===========================================================\033[0m\n");
        end

        `uvm_info("final_phase","Exiting...",UVM_HIGH)
    endfunction: final_phase


endclass: uart_base_test
