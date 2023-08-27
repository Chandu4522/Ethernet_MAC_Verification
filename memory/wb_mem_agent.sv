class wb_mem_agent extends uvm_agent;
`uvm_component_utils(wb_mem_agent)
`NEW_COMP

memory memory_i;

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	memory_i = memory::type_id::create("memmory_i", this);


endfunction
endclass