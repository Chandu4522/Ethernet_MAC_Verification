//wb_clk is generated in top module, it is input to BFM, DUT and monitor
interface wb_proc_intf(input wb_clk_i, wb_rst_i);

	bit	[31:0]	wb_dat_i;		//WISHBONE data input
	bit	[31:0]	wb_dat_o;		//WISHBONE data output
	bit			wb_err_o;		//WISHBONE error output
	bit	[11:2]	wb_adr_i;		//WISHBONE address input, 1:0 is always 00 => word aligned
	bit	[3:0]	wb_sel_i;		//WISHBONE bye select input
	bit			wb_we_i;		//WISHBONE write enable input
	bit			wb_cyc_i;		//WISHBONE cycle input
	bit			wb_stb_i;		//WISHBONE strobe input
	bit			wb_ack_o;		//WISHBONE acknowledge output
	bit 		int_o;			//Interrupt Bit
endinterface