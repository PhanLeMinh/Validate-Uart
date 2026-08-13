`uvm_analysis_imp_decl(_lhs_tx)
`uvm_analysis_imp_decl(_lhs_rx)
`uvm_analysis_imp_decl(_rhs_tx)
`uvm_analysis_imp_decl(_rhs_rx)

class uart_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(uart_scoreboard)

    uart_configuration lhs_cfg;
    uart_configuration rhs_cfg;

    uart_transaction lhs_tx_q[$];
    uart_transaction lhs_rx_q[$];
    uart_transaction rhs_tx_q[$];
    uart_transaction rhs_rx_q[$];

    int pass_count;
    int fail_count;

    uvm_analysis_imp_lhs_tx#(uart_transaction,uart_scoreboard) lhs_tx_export;
    uvm_analysis_imp_lhs_rx#(uart_transaction,uart_scoreboard) lhs_rx_export;
    uvm_analysis_imp_rhs_tx#(uart_transaction,uart_scoreboard) rhs_tx_export;
    uvm_analysis_imp_rhs_rx#(uart_transaction,uart_scoreboard) rhs_rx_export;

    function new(string name="uart_scoreboard", uvm_component parent);
        super.new(name,parent);
    endfunction:new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        lhs_tx_export = new("lhs_tx_export",this);
        lhs_rx_export = new("lhs_rx_export",this);
        rhs_tx_export = new("rhs_tx_export",this);
        rhs_rx_export = new("rhs_rx_export",this);

        if(!uvm_config_db#(uart_configuration)::get(this,"","lhs_cfg",lhs_cfg))
            `uvm_fatal(get_type_name(),"Fail to get lhs_cfg from uvm_config_db")
        if(!uvm_config_db#(uart_configuration)::get(this,"","rhs_cfg",rhs_cfg))
            `uvm_fatal(get_type_name(),"Fail to get rhs_cfg from uvm_config_db")
    endfunction:build_phase
    
    virtual task run_phase(uvm_phase phase);
    endtask

    function void write_lhs_tx(uart_transaction uart_trans);
        `uvm_info(get_type_name(),$sformatf("LHS TX received: %b",uart_trans.data),UVM_HIGH)
        lhs_tx_q.push_back(uart_trans);
        com_path1();
    endfunction

    function void write_rhs_rx(uart_transaction uart_trans);
        `uvm_info(get_type_name(),$sformatf("RHS RX received: %b",uart_trans.data),UVM_HIGH)
        rhs_rx_q.push_back(uart_trans);
        com_path1();
    endfunction

    function void write_rhs_tx(uart_transaction uart_trans);
        `uvm_info(get_type_name(),$sformatf("RHS TX received: %b",uart_trans.data),UVM_HIGH)
         rhs_tx_q.push_back(uart_trans);
         com_path2();
    endfunction

    function void write_lhs_rx(uart_transaction uart_trans);
        `uvm_info(get_type_name(),$sformatf("LHS RX received: %b",uart_trans.data),UVM_HIGH)
        lhs_rx_q.push_back(uart_trans);
        com_path2();
    endfunction

    function void com_path1();
        uart_transaction tx_trans,rx_trans;
        if(lhs_tx_q.size()==0 | rhs_rx_q.size()==0) return;

        tx_trans = lhs_tx_q.pop_front();
        rx_trans = rhs_rx_q.pop_front();
        compare(tx_trans,rx_trans,"[PATH1: LHS_TX and RHS_RX]",lhs_cfg);
    endfunction: com_path1

    function void com_path2();
        uart_transaction tx_trans,rx_trans;
        if(rhs_tx_q.size()==0|lhs_rx_q.size()==0) return;

        tx_trans = rhs_tx_q.pop_front();
        rx_trans = lhs_rx_q.pop_front();
        compare(tx_trans,rx_trans,"[PATH2: RHS_TX and LHS_RX]",rhs_cfg);
    endfunction:com_path2

    function void compare(uart_transaction tx_trans, uart_transaction rx_trans, string path_name, uart_configuration uart_cfg);
        logic[`UART_DATA_WIDTH-1:0] tx_data,rx_data;

        tx_data = tx_trans.data & ((1 << uart_cfg.data_width) - 1);
        rx_data = rx_trans.data & ((1 << uart_cfg.data_width) - 1);

        if(tx_data == rx_data) begin
            pass_count++;
            `uvm_info(get_type_name(),$sformatf("%s [PASSED] - TX=0x%0b,RX=0x%0b", path_name,tx_data,rx_data),UVM_LOW)
        end 
        else begin
            fail_count++;
            `uvm_error(get_type_name(),$sformatf("%s [FAILED] - TX=0x%0b,RX=0x%0b",path_name,tx_data,rx_data))
        end
    endfunction: compare

    virtual function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name()," ==========SCOREBOARD SUMARY==========",UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("[PASS]:%0d | [FAIL]:%0d",pass_count,fail_count),UVM_LOW)
        if(fail_count==0)
            `uvm_info(get_type_name(),"\033[32m[TEST PASSED]\033[0m", UVM_LOW)
        else
            `uvm_error(get_type_name(),"\033[31m[TEST FAILED]\033[0m")
    endfunction: report_phase
endclass
