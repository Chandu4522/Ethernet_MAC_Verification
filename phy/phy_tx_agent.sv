class phy_tx_agent extends uvm_agent;
`uvm_component_utils(phy_tx_agent)
`NEW_COMP

phy_tx_drv drv;

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	drv = phy_tx_drv::type_id::create("drv", this);
endfunction

endclass