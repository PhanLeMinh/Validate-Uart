class uart_sequence extends uvm_sequence#(uart_transaction);
    `uvm_object_utils(uart_sequence)

    function new(string name = "uart_sequence");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info(get_type_name(),"Entered...",UVM_LOW)
        req = uart_transaction::type_id::create("req");
        start_item(req);
        if(req.randomize()) begin
            `uvm_fatal(get_type_name(),"Fail to randomize uart_transaction")
        end
        `uvm_info(get_type_name(),$sformatf("Sending transaction:\n%s",req.sprint()),UVM_LOW)
        finish_item(req);
        get_response(rsp);

        `uvm_info(get_type_name(),$sformatf("Received transaction:\n%s",req.sprint()),UVM_LOW)
    endtask: body
endclass
