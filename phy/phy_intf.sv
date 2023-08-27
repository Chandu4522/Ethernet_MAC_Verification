interface phy_intf();
bit			mtx_clk_pad_i;
bit [3:0]	mtxd_pad_o;	
bit 		mtxen_pad_o;
bit 		mtxen_err_pad_o;

//RX
bit			mrx_clk_pad_i;
bit	[3:0]	mrxd_pad_i;
bit			mrxdv_pad_i;
bit			mrxerr_pad_i;

//Common Tx and Rx
bit 		mcoll_pad_i;
bit 		mcrs_pad_i;
endinterface