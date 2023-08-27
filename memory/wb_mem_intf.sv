interface wb_mem_intf(input wb_clk, wb_rst);
	bit	[31:0]	m_wb_adr_o;
	bit	[3:0]	m_wb_sel_o;
	bit			m_wb_we_o;
	bit	[31:0]	m_wb_dat_i;
	bit	[3:0]	m_wb_dat_o;		
	bit			m_wb_cyc_o;		
	bit			m_wb_stb_o;		
	bit			m_wb_ack_i;	
	bit			m_wb_err_i;	
	bit	[2:0]	m_wb_cti_o;		//cycle type identifier
	bit	[1:0]	m_wb_bte_o;		//burst type extension
	clocking slave_cb@(posedge wb_clk);
	default input #0 output #1;
	input wb_rst;
	input	m_wb_adr_o;
	input	m_wb_sel_o;
	input	m_wb_we_o;
	output	m_wb_dat_i;
	input	m_wb_dat_o;		
	input	m_wb_cyc_o;		
	input	m_wb_stb_o;		
	output	m_wb_ack_i;	
	output	m_wb_err_i;	
	input	m_wb_cti_o;		
	input	m_wb_bte_o;
	endclocking









endinterface