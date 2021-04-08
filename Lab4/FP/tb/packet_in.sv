class packet_in extends uvm_sequence_item;
    rand bit [31:0] A,B; 

//	constraint rangeee { A inside { [ 1:16777215 ] };
//			 B inside { [ 1:16777215 ] }; }
    `uvm_object_utils_begin(packet_in)
        `uvm_field_int(A, UVM_ALL_ON|UVM_HEX)
        `uvm_field_int(B, UVM_ALL_ON|UVM_HEX)
    `uvm_object_utils_end

    function new(string name="packet_in");
        super.new(name);
    endfunction: new
endclass: packet_in
