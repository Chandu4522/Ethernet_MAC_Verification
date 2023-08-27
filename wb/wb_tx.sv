class wb_tx extends uvm_sequence_item;
rand bit [31:0] addr;
rand bit [31:0] data;
rand bit wr_rd;
rand bit [3:0] sel;

`uvm_object_utils_begin(wb_tx)
	`uvm_field_int(addr,UVM__ALL_ON)
	`uvm_field_int(data,UVM__ALL_ON)
	`uvm_field_int(wr_rd,UVM__ALL_ON)
	`uvm_field_int(sel,UVM__ALL_ON)
`uvm_object_utils_end
`NEW_OBJ

constraint soft_c { 
	soft sel ==4'b1111;
	soft addr[1:0] == 2'b00;  // addr is always a multiple of 4
}

endclass