class wb_adapter extends uvm_reg_adapter;
`uvm_object_utils(wb_adapter)
	function new(string name = "wb_adapter");
		super.new(name);
	endfunction
	
	virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
		wb_tx wb = wb_tx::type_id::create("wb");
		wb.wr_rd = (rw.kind ==UVM_EAD) ? 0 : 1;
		wb.addr  = rw.addr;
		wb.data  = rw.data;
		return wb;
	endfunction: reg2bus

	virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
	
	wb_tx wb;
	if (!$cast(wb, bus_item)) begin
		`uvm_fatal("NOT_WB_TYPE", "Provided bus_item is not of the correct type")
		return;
	end
	rw.kind = wb.wr_rd ? UVM_WRITE : UVM_READ;
	rw.addr = wb.addr;
	rw.data = wb.data;
	rw.status = UVM_IS_OK;
	endfunction: bus2reg

endclass: wb_adapter