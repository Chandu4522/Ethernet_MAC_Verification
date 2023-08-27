`define NEW_COMP \
funciton new(string name, uvm_component parent); \
	super.new(name, parent); \
endfunction

`define NEW_OBJ \
funciton new(string name = ""); \
	super.new(name); \
endfunction


class ethmac_common;
static bit [31:0] regmaskA[20:0];
static bit int_o_generated; 
static bit [6:0] exp_int_src_reg_val;

function new();
	
	regmaskA[0] = {15'h0, 17'h1FFFF};
	regmaskA[1] = {25'h0, 7'h0};
	regmaskA[2] = {25'h0, 7'h7F};
	regmaskA[3] = {25'h0, 7'h7F};
	regmaskA[4] = {25'h0, 7'h7F};
	regmaskA[5] = {25'h0, 7'h7F};
	regmaskA[6] = 32'hFFFF_FFFF;
	regmaskA[7] = {12'h0, 4'hF, 10'h0, 6'h3F};
	regmaskA[8] = {24'h0, 8'hFF};
	regmaskA[9] = {29'h0, 3'h7};
	regmaskA[10] = {23'h0, 9'h1F};
	regmaskA[11] = {29'h0, 3'h4};  // lower 2 bits are 0's (status and read bits)
	regmaskA[12] = {19'h0, 5'h1, 3'h0, 5'h1FF};
	regmaskA[13] = {16'h0, 16'hFFFF};
	regmaskA[14] = {16'h0, 16'hFFFF};
	regmaskA[15] = {29'h0, 3'h7};
	regmaskA[16] = 32'hFFFF_FFFF;
	regmaskA[17] = {16'h0, 16'hFFFF};
	regmaskA[18] = 32'hFFFF_FFFF;
	regmaskA[19] = 32'hFFFF_FFFF;
	regmaskA[20] = {15'h0, 17'h1FFFF};
endfunction




endclass