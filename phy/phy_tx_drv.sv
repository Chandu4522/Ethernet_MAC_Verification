class phy_tx_drv extends uvm_driver;   //TODO
    `uvm_component_utils(phy_tx_drv)
    `NEW_COMP
    virtual phy_intf vif;
    real clk_tp;

    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_resource_db#(virtual phy_intf)::read_by_name("GLOBAL", "PHY_VIF", vif, this);
    uvm_resource_db#(int)::read_by_name("GLOBAL", "PHY_CLK_TP", clk_tp, this);
    endfunction


    task run_phase(uvm_phase phase);
    forever begin
        #(clc_tp/2.0) vif.mtx_clk_pad_i = ~vif.mtx_clk_pad_i;
    end
endclass