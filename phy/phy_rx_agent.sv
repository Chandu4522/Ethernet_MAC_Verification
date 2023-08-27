class phy_rx_agent extends uvm_agent;
`uvm_component_utils(phy_rx_agent)
`NEW_COMP

phy_rx_drv drv;


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	drv = phy_rx_drv::type_id::create("drv", this);
endfunction

endclass