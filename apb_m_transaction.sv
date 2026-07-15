`include "defines.svh"
class apb_m_transaction;

	rand bit [`DW-1:0]PRDATA;
	rand bit PREADY;
	rand bit PSLVERR;
	rand bit transfer;
	rand bit write_read;
	rand bit [`AW-1:0]addr_in;
	rand bit [`DW-1:0]wdata_in;
	rand bit [(`DW/8) - 1: 0]strb_in;

	bit [`AW-1:0] PADDR;
	bit PSEL;
	bit PENABLE;
	bit PWRITE;
	bit [`DW-1:0]PWDATA;
	bit [(`DW/8)-1:0]PSTRB;
	bit [`DW-1:0]rdata_out;
	bit transfer_done;
	bit error;


	constraint strobe{write_read -> strb_in inside {[0:(2**(`DW/8))-1]};}
	constraint tnsf{ transfer == 1;}
	constraint wr_rd_strb{!write_read -> (strb_in == 0) ;}
//	constraint ready_c { PREADY == 1;}
	
	virtual function apb_m_transaction copy();
		copy = new();
		copy.PRDATA = this.PRDATA;
		copy.PREADY = this.PREADY;
		copy.PSLVERR = this.PSLVERR;
		copy.transfer = this.transfer;
		copy.write_read = this.write_read;
		copy.addr_in = this.addr_in;
		copy.wdata_in = this.wdata_in;
		copy.strb_in = this.strb_in;
		return copy;
	endfunction
endclass
/*
class write_transaction extends apb_m_transaction;
	constraint wr_c{transfer == 1; write_read == 1; strb_in inside {[1:(2**(`DW/8))-1]};}

	virtual function write_transaction copy1();
		copy1 = new();
		copy1.PRDATA = this.PRDATA;
		copy1.PREADY = this.PREADY;
		copy1.PSLVERR = this.PSLVERR;
		copy1.transfer = this.transfer;
		copy1.write_read = this.write_read;
		copy1.addr_in = this.addr_in;
		copy1.wdata_in = this.wdata_in;
		copy1.strb_in = this.strb_in;
		return copy;
	endfunction
endclass

class read_transaction extends apb_m_transaction;
	constraint wr_c{transfer == 1; write_read == 0; strb_in == 0;}

	virtual function read_transaction copy2();
		copy2 = new();
		copy2.PRDATA = this.PRDATA;
		copy2.PREADY = this.PREADY;
		copy2.PSLVERR = this.PSLVERR;
		copy2.transfer = this.transfer;
		copy2.write_read = this.write_read;
		copy2.addr_in = this.addr_in;
		copy2.wdata_in = this.wdata_in;
		copy2.strb_in = this.strb_in;
		return copy;
	endfunction
endclass
*/
