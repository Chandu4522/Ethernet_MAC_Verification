class wb_proc_agent extends uvm_agent;
wb_proc_drv		drv;
wb_proc_sqr		sqr;

//mon, cov
`uvm_component_utils(wb_proc_agent)
`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	drv = wb_proc_drv::type_id::create("drv", this);
	sqr = wb_proc_sqr::type_id::create("sqr", this);
endfunction

function void connect-phase(uvm_phase);
	drv.seq_item_port.connect(sqr.seq_item_export);
endfunction
endclass