class uart_monitor extends uvm_monitor;
    `uvm_component_utils(uart_monitor)
    
    virtual uart_if uart_vif;
    uart_configuration uart_cfg;
    uvm_analysis_port #(uart_transaction) monitor_rx;
    uvm_analysis_port #(uart_transaction) monitor_tx;

    function new (string name = "uart_monitor", uvm_component parent);
        super.new(name,parent);
        monitor_rx = new("monitor_rx",this);
        monitor_tx = new("monitor_tx",this);
    endfunction: new
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual uart_if)::get(this,"","vif",uart_vif))
            `uvm_fatal(get_type_name(), $sformatf("Failed to get uart_vif from uvm_config_db!"))
        if(!uvm_config_db #(uart_configuration)::get(this,"","cfg",uart_cfg))
            `uvm_fatal(get_type_name(), $sformatf("Failed to get uart_cfg from uvm_config_db!"))
    endfunction:build_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            fork
                capture_tx(); 
                capture_rx(); 
            join
        end
    endtask

    function int cal_total_bit();
        int parity_bit;
        parity_bit = (uart_cfg.parity == uart_configuration::NONE) ? 0 : 1;
        return uart_cfg.data_width + parity_bit + uart_cfg.num_of_stop_bit;
    endfunction:cal_total_bit
   
    task capture_tx();
        uart_transaction trans;
        int total_bit;
        int bit_time;
        int cal_parity, act_parity, exp_parity;

        trans = uart_transaction::type_id::create("trans");
        bit_time = 1_000_000 / uart_cfg.baud_rate;
        total_bit = cal_total_bit();
        cal_parity = 0;

        wait(uart_vif.tx == 1'b0);
        #(bit_time + bit_time/2);
        `uvm_info(get_type_name(),$sformatf("Start capture TX"), UVM_LOW);

        // Data bit
        for(int i = 0; i < uart_cfg.data_width; i++) begin
            trans.data[i] = uart_vif.tx;
            cal_parity = cal_parity ^ uart_vif.tx;
            #(bit_time);
        end

        // Parity bit
        if(uart_cfg.parity != uart_configuration::NONE) begin   
            act_parity = uart_vif.tx;

            case(uart_cfg.parity)   
                uart_configurtaion::EVEN: exp_parity = cal_parity;
                uart_configuration::ODD: exp_parity = ~cal_parity;
            endcase

            if(act_parity !== exp_parity) begin
                `uvm_error(get_type_name(),$sformatf("[Error] Parity bit error: mode = %0s, act = %0b, exp = %0b",uart_cfg.parity.name(),act_parity,exp_parity))
            end
        end
    
        // Stop bit
        for(int i = 0; i < uart_cfg.num_of_stop_bit;i++) begin
            if(uart_vif.tx !== 1'b1)
                `uvm_error(get_type_name(),$sformatf("[Error] Stop bit error #%0d = %0b (expected 1)",i,uart_vif.tx))
            if(i != uart_cfg.num_of_stop_bit - 1)
                #(bit_time);
            else
                #(bit_time/2);
        end

        `uvm_info(get_type_name(), $sformatf("\033[92mTX captured: %0b\033[0m", trans.data),UVM_LOW)
         monitor_tx.write(trans);
    endtask
    
    task capture_rx();
        uart_transaction trans;
        int total_bit;
        int bit_time;
        int cal_parity, act_parity, exp_parity;

        trans = uart_transaction::type_id::create("trans");
        total_bit = cal_total_bit();
        bit_time  = 1_000_000/uart_cfg.baud_rate;
        cal_parity = 0;

        wait(uart_vif.rx == 1'b0);

        #(bit_time + bit_time/2);

        `uvm_info(get_type_name(),"Start capture RX",UVM_LOW)

        // Data bit
        for(int i=0;i < uart_cfg.data_width;i++) begin
            trans.data[i] = uart_vif.rx;
            cal_parity = cal_parity ^ uart_vif.rx;
            #(bit_time);
        end
        
        // Parity bit
        if(uart_cfg.parity != uart_configuration::NONE) begin
            act_parity = uart_vif.rx;
            
            case(uart_cfg.parity)
                uart_configuration::EVEN: exp_parity = cal_parity;
                uart_configuration::ODD:  exp_parity = ~cal_parity;
            endcase

            if(act_parity !== exp_parity) begin
                `uvm_error(get_type_name(),$sformatf("[Error] Parity bit error: mode = %0s, act = %0b, exp = %0b",uart_cfg.parity.name(),act_parity,exp_parity))
            end

            #(bit_time);
        end
        
        
        // Stop bit
        for(int i = 0; i < uart_cfg.num_of_stop_bit;i++) begin
            if(uart_vif.tx !== 1'b1)
                `uvm_error(get_type_name(),$sformatf("[Error] Stop bit error #%0d = %0b (expected 1)",i,uart_vif.tx))
            if(i != uart_cfg.num_of_stop_bit - 1) 
                #(bit_time);
            else
                #(bit_time/2);
        end

        `uvm_info(get_type_name(), $sformatf("\033[92mRX captured: %0b\033[0m",trans.data),UVM_LOW)
        monitor_rx.write(trans);
    endtask
    
endclass: uart_monitor
