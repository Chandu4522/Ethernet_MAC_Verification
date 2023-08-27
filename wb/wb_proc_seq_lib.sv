class wb_proc_base_seq extends uvm_sequence#(wb_tx);
`uvm_object_utils(wb_proc_base_seq)
`NEW_OBJ

task pre_body();
uvm_phase phase = get_starting_phase();
if(phase != null) phase.raise_objection(this);
endtask

task pre_body();
if(phase != null) phase.drop_objection(this);
endtask
endclass

class wb_reg_read_seq extends wb_proc_base_seq;
`uvm_object_utils(wb_reg_read_seq)
`NEW_OBJ

task body();
for(int i=0, i<21, i++) begin
	$display("i = %0d", i);
	`uvm_do_with(req, {req.wr_rd == 0; req.addr ==i;})
end
endtask
endclass


class wb_reg_write_read_seq extends wb_proc_base_seq;
`uvm_object_utils(wb_reg_write_read_seq)
`NEW_OBJ

task body();
	bit [31:0] data_t;

//writing all registers
	for(int i=0, i<21, i++) begin
		data_t = $random & ethmac_common::regmaskA[i];  //making sure reserved bits are 0's
		`uvm_do_with(req, {req.wr_rd == 1; req.addr ==i; req.data ==data_t;})
	end
//reading all registers
	for(int i=0, i<21, i++) begin
		`uvm_do_with(req, {req.wr_rd == 0; req.addr ==i;})
	end
endtask
endclass


class wb_reg_wr_rd_rm_seq extends wb_proc_base_seq;    ///front door access.
uvm_reg mac_regs[$];   //queue of uvm_reg
uvm_reg_data_t ref_data;  //will be used for compare purpose
rand uvm_reg_data_t data;
uvm_reg_data_t miicommand_wr_data;
uvm_status_e status;
`uvm_object_utils(wb_reg_wr_rd_rm_seq)
`NEW_OBJ

task body();
	mac_reg_block mac_rm;
	int errors;   // used for counting errors
	string reg_name;
	uvm_reg_addr_t addr;
	super.body;
	uvm_resource_db#(mac_reg_block)::read_by_name("GLOBAL", "MAC_RAM", mac_rm, this);
	mac_rm.get_registers(mac_regs);  //getting all mac registers into handle
	
	// set errors = 0
	errors = 0;
	repeat(5) begin  //repeat(10)
		mac_regs.shuffle();
		foreach(mac_regs[i]) begin
			if(!this.randomize()) begin
				`uvm_error("body", "randomization error")
			end


			/* addr = mac_regs[i].get_addresses();   ////forcibly trying to rectify the error. one through reg name and one though reg address   
			if (addr == 32'hb) begin                    //////////NOT RECOMMENDED. ( same as not allowing some of the test conditions to occur.)
				data[0] = 0;
			end
			//reg_name = mac_regs[i].get_name();
			if (reg_name == "miicommand") begin
				data[0] = 0;
			end */

			// if data[0] = 1, then predit/make sure  that miistate[1][2] both should be 1  /////recommended.
			// update the register model so that miistatus[2:1] = 2'b11 

			reg_name = mac_regs[i].get_name();
			if (reg_name == "miicommand") begin
				miicommand_wr_data = data;
			end
			if (reg_name == "txbdnum") begin
				if (data > 8'h80) data = 8'h7F;
			end
			mac_regs[i].write(status, data, .parent(this)); //performing write to the register
			// uvm_reg_rw kind of object --> adapter 
		end

			if (miicommand_wr_data[0] == 1) begin             ///////////continuation from line 83-89
				reg_block.miistatus.predit(3'b110);        ////updating the register model value for the miistatus
			end


		mac_regs.shuffle();
		foreach(mac_regs[i]) begin
			ref_data = mac_regs[i].get(); // get the desired value of the register fromthe register model (from ref model in TB)
			//queue of 21 registers


			mac_regs[i].read(status, data, .parent(this)); //get the register value ftom teh DUT register.
			   
			if(ref_data != data) begin
				`uvm_error("REG_TEST_SEQ", $sformatf("get/read: Read error for %s: Expected: %0h Actual: %0h", mac_regs[i].get_name(), ref_data, data))
				errors++
            end
		end
	end
	endtask: body
endclass
	


class wb_reg_bd_wr_rd_rm_seq extends wb_proc_base_seq;    //back door access.
uvm_reg mac_regs[$];   //queue of uvm_reg
uvm_reg_data_t ref_data;  //will be used for compare purpose
rand uvm_reg_data_t data;
uvm_status_e status;
`uvm_object_utils(wb_reg_bd_wr_rd_rm_seq)
`NEW_OBJ

task body();
	mac_reg_block mac_rm;
	int errors;   // used for counting errors
	super.body;
	uvm_resource_db#(mac_reg_block)::read_by_name("GLOBAL", "MAC_RAM", mac_rm, this);
	mac_rm.get_registers(mac_regs);  //getting all mac registers into handle
	
	// set errors = 0
	errors = 0;
	
		mac_regs.shuffle();
		foreach(mac_regs[i]) begin
			if(!this.randomize()) begin
				`uvm_error("body", "randomization error")
			end
			mac_regs[i].poke(status, data, .parent(this)); //performing write to the register          //   poke is backdoor wirte.
			// uvm_reg_rw kind of object --> adapter 
		end
		mac_regs.shuffle();
		foreach(mac_regs[i]) begin
			ref_data = mac_regs[i].get(); // get the desired value of the register fromthe register model (from ref model in TB)
			//queue of 21 registers
			mac_regs[i].peek(status, data, .parent(this)); //get the register value ftom teh DUT register.         // peek is backdoor read.
			   
			if(ref_data != data) begin
				`uvm_error("REG_TEST_SEQ", $sformatf("get/read: Read error for %s: Expected: %0h Actual: %0h", mac_regs[i].get_name(), ref_data, data))
				errors++
            end
			else begin
				`uvm_info("REG_TEST_SEQ:", $sprintf("register compare passed: %s, data = %h", mac_regs[i].get_name(), data),UVM_LOW)
		end
	endtask: body
endclass

class wb_reg_read_rm_seq extends wb_proc_base_seq;    ///front door access.
uvm_reg mac_regs[$];   //queue of uvm_reg
uvm_reg_data_t ref_data;  //will be used for compare purpose
rand uvm_reg_data_t data;
uvm_reg_data_t miicommand_wr_data;
uvm_status_e status;
`uvm_object_utils(wb_reg_read_rm_seq)
`NEW_OBJ

task body();
	mac_reg_block mac_rm;
	int errors;   // used for counting errors
	string reg_name;
	uvm_reg_addr_t addr;
	super.body;
	uvm_resource_db#(mac_reg_block)::read_by_name("GLOBAL", "MAC_RAM", mac_rm, this);
	mac_rm.get_registers(mac_regs);  //getting all mac registers into handle
	
	// set errors = 0
	errors = 0;
	repeat(5) begin  //repeat(10)
		mac_regs.shuffle();
		foreach(mac_regs[i]) begin
			ref_data = mac_regs[i].get_reset(); // get the desired reset value of the register fromthe register model (from ref model in TB)
			//queue of 21 registers
			mac_regs[i].read(status, data, .parent(this)); //get the register value ftom teh DUT register.   
			if(ref_data != data) begin
				`uvm_error("REG_TEST_SEQ", $sformatf("get/read: Read error for %s: Expected: %0h Actual: %0h", mac_regs[i].get_name(), ref_data, data))
				errors++
            end
		end
	end
	endtask: body
endclass


///////////funcitonal SANITY test sequences ------checking for the control and Data Paths.



class mac_fd_tx_seq extends wb_proc_base_seq;    ///front door access.
	uvm_status_e status;
	rand uvm_reg_data_t moder_data;
	rand uvm_reg_data_t int_mask_data;
	`uvm_object_utils(mac_fd_tx_seq)
	`NEW_OBJ

/////Important task is identifying waht to do in the sequence body method.

	task body();
		mac_reg_block reg_block;
		bit [31:0] data_t;
		string reg_name;
		uvm_reg_addr_t addr;
		//we need the register model handle. 
		//`uvm_do_with(req, {req.addr=13'h0; req.data == data_t; req.write ==1;})  ----> normal way of doing it.
		//But we do it through register model. For that we get the register block from the uvm_resource_db
		uvm_resource_db#(mac_reg_block)::read_by_name("GLOBAL", "MAC_RAM", reg_block, this);
		data[16] = 0;   //RECSMALL
		data[15] = 0;   // PADEN
		data[14] = 0;   //HUGEN
		data[13] = 0;   // crcen
		data[12] = 0;   //dlycrcen
		data[11] = 0;   // rsvd
		data[10] = 1;   // full duplex mode
		data[9] = 0;    // exdfren
		data[8] = 0;    // nobckof
		data[7] = 0;	// loopbck
		data[6] = 0;	// ifg
		data[5] = 0;	// pro
		data[4] = 0;	// iam
		data[3] = 0;	// bro
		data[2] = 0;	// nopre
		data[1] = 0;	// txen is 0 for now as the tranmit buffers don't have any data
		data[0] = 0;	// rxen
		reg_block.moder.write(status, moder_data);

		//int mask write   --------> for checking interrupt generation
		int_mask_data[0] = 1;
		reg_block.intmask.write(status,int_mask_data);

		//load the transmit buffers.
		// we can't load these tx buffer (tx_bd) using the register model as we haven't declared it in the database yet.
		// so we do it normally.
		data_t = {16'b200, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 2'b0, 1'b0, 4'b0, 1'b0, 1'b0, 1'b0, 1'b0}; //512 bytes. example length size.
		// 400 is actual address, but drive only 100 by removing the 2 lower bits.
		`uvm_do_with(req, {req.addr=10'h100; req.data == data_t; req.wr_rd ==1'b1;})
		data_t = 32'h1000_0000;   // transmit pointer --> pointing to the address which

		// 404 is actual address, but drive only 101 by removing the 2 lower bits.
		`uvm_do_with(req, {req.addr=13'h101; req.data == data_t; req.wr_rd ==1'b1;})
		//rest all fields are same, only the write TXEN=1
		moder_data[1] = 1; //TXEN = 1
		reg_block.moder.write(status, moder_data);  
	endtask: body
endclass





class mac_isr_seq extends wb_proc_base_seq;    ///front door access.
	uvm_status_e status;
	`uvm_object_utils(mac_isr_seq)
	`NEW_OBJ

/////Important task is identifying waht to do in the sequence body method.

	task body();
		mac_reg_block reg_block;
		bit [31:0] data_t;
		string reg_name;
		uvm_reg_addr_t addr;
		uvm_reg_data int_crc_reg_data;
		int errors;  //used for counting the errors.
		uvm_resource_db#(mac_reg_block)::read_by_name("GLOBAL", "MAC_RAM", reg_block, this);
		forever begin 
			wait(ethmac_common::int_o_generated == 1);
				`uvm("INT_SRC", "int_o generated")
				(ethmac_common::int_o_generated == 0;
				reg_block.intsrc.read(status, int_crc_reg_data)
				if(int_src_reg_data != ethmac_common::exp_int_src_reg_val) begin
					`uvm_error("INT_SRC", "int source register read data doesn't match exp data")
				end
				else begin
					reg_block.intsrc.write(status, int_src_reg_data);
				end
		end

	endtask: body
endclass