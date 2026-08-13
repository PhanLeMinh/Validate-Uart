class uart_error_catcher extends uvm_report_catcher;
    `uvm_object_utils(uart_error_catcher)

    string error_msg_q[$];

    function new(string name="uart_error_catcher");
        super.new(name);
    endfunction

    function bit str_contains(string full_str,string pattern);
        int i;
        if(pattern.len() == 0 || pattern.len() > full_str.len())
            return 0;
        for(i = 0; i <= full_str.len() - pattern.len(); i++) begin
            if(full_str.substr(i,i + pattern.len() - 1) == pattern)
                return 1;
        end
        return 0;
    endfunction

    // Implement catcher in this function
    virtual function action_e catch();
        string str_cmp;

        if(get_severity() == UVM_ERROR) begin
            foreach(error_msg_q[i]) begin   
                str_cmp = error_msg_q[i];
                if(str_contains(get_message(), str_cmp)) begin
                    set_severity(UVM_INFO);
                    `uvm_info("REPORT_CATCHER",$sformatf("Demote below error message: %s",str_cmp),UVM_NONE)
                end
            end
        end
        return THROW;
    endfunction

    virtual function void add_error_catcher_msg(string str);
        error_msg_q.push_back(str);
    endfunction
endclass
