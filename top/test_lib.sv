class ethmac_base_test extends uvm_test;
ethmac_env env;
`uvm_component_utils(ethmac_base_test)
`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	env = ethmac_env::type_id::create("env", this);
endfunction

function void end_of_elaboration_phase(uvm_phase phase);    // Print the UVM testbench structure in the end_of_elaboration_phase
	uvm_top.print_topology();
endfunction
endclass


class ethmac_reg_read_test extends ethmac_base_test;
`uvm_component_utils(ethmac_reg_read_test)
`NEW_COMP

task run_phase(uvm_phase phase);
	wb_reg_read_seq read_seq = wb_reg_read_seq::type_id::create("read_seq");
	phase.raise_objection(this);
	phase.phase_done.set_drain_time(this, 100);
	read_seq.start(env.proc_agent_i.sqr);
	phase.drop_objection(this);
endtask
endclass



class mac_reg_wr_rd_rm_test extends ethmac_base_test;
`uvm_component_utils(mac_reg_wr_rd_rm_test)
`NEW_COMP

task run_phase(uvm_phase phase);
	wb_reg_wr_rd_rm_seq write_read_seq = wb_reg_wr_rd_rm_seq::type_id::create("write_read_seq");
	phase.raise_objection(this);
	phase.phase_done.set_drain_time(this, 100);
	write_read_seq.start(env.proc_agent_i.sqr);
	phase.drop_objection(this);
endtask
endclass


class mac_reg_bd_wr_rd_rm_test extends ethmac_base_test;
`uvm_component_utils(mac_reg_bd_wr_rd_rm_test)
`NEW_COMP

task run_phase(uvm_phase phase);
	wb_reg_bd_wr_rd_rm_seq write_read_reg_model_seq = wb_reg_bd_wr_rd_rm_seq::type_id::create("write_read_seq");
	phase.raise_objection(this);
	phase.phase_done.set_drain_time(this, 100);
	write_read_seq.start(env.proc_agent_i.sqr);
	phase.drop_objection(this);
endtask
endclass


class mac_reg_read_rm_test extends ethmac_base_test;
`uvm_component_utils(mac_reg_read_rm_test)
`NEW_COMP

task run_phase(uvm_phase phase);
	wb_reg_read_rm_seq read_seq = wb_reg_read_rm_seq::type_id::create("read_seq");
	phase.raise_objection(this);
	phase.phase_done.set_drain_time(this, 100);
	write_read_seq.start(env.proc_agent_i.sqr);
	phase.drop_objection(this);
endtask
endclass




////finctional test cases for sanity check. -  Checking control path and data path.



class mac_10mbps_fd_tx_test extends ethmac_base_test;
`uvm_component_utils(mac_10mbps_fd_tx_test)
`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);	
	// 10Mhz => TP in ns = 1000/freq =400ns
	uvm_resource_db#(int)::set("GLOBAL", "PHY_CLK_TP", 400, this);
	ethmac_common::exp_int_src_reg_val = 7'b000_0001;
endfunction

task run_phase(uvm_phase phase);
	mac_10mbps_fd_tx_seq fd_tx_seq = mac_10mbps_fd_tx_seq::type_id::create("fd_tx_seq");
	phase.raise_objection(this);
	phase.phase_done.set_drain_time(this, 100);
	write_read_seq.start(env.proc_agent_i.sqr);
	//I should wait till the tx completes, only then end the simulation
	#200000; //TODOmnbfa
	phase.drop_objection(this);
endtask
endclass
///////////10mbps test is taking a lot of time. so use the 100 mbps test.



class mac_100mbps_fd_tx_test extends ethmac_base_test;
`uvm_component_utils(mac_100mbps_fd_tx_test)
`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);	
	// 100Mhz => TP in ns = 1000/freq =40ns
	uvm_resource_db#(int)::set("GLOBAL", "PHY_CLK_TP", 40, this);
endfunction

task run_phase(uvm_phase phase);
	mac_fd_tx_seq fd_tx_seq = mac_fd_tx_seq::type_id::create("fd_tx_seq");
	mac_isr_seq isr_seq = mac_isr_seq::type_id::create("isr_seq");
	phase.raise_objection(this);
	phase.phase_done.set_drain_time(this, 500);
	fork
	isr_seq.start(env.proc_agent_i.sqr);  // forever sequence.	
	join_none
	
	fd_tx_seq.start(env.proc_agent_i.sqr);
	//I should wait till the tx completes, only then end the simulation
	wait (ethmac_common::int_o_generated == 1'b1);
	phase.drop_objection(this);
endtask
endclass