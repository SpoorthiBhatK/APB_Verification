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


//	constraint strobe{write_read -> strb_in inside {[0:(2**(`DW/8))-1]};}
	constraint tnsf{ transfer == 1;}
	constraint wr_rd_strb {
				    if(write_read)
					strb_in inside {[1:(2**(`DW/8))-1]};
				    else
					strb_in == 0;
				}
//	constraint ready_c { PREADY == 1;}
	constraint ready_dist{ PREADY dist {0:= 1, 1:=1};}
	
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


//Write
class apb_m_write_transaction extends apb_m_transaction;

    constraint write_only {
        write_read == 1;
    }

    virtual function apb_m_transaction copy();
        apb_m_write_transaction copy_tr;
        copy_tr = new();

        copy_tr.PRDATA     = this.PRDATA;
        copy_tr.PREADY     = this.PREADY;
        copy_tr.PSLVERR    = this.PSLVERR;
        copy_tr.transfer   = this.transfer;
        copy_tr.write_read = this.write_read;
        copy_tr.addr_in    = this.addr_in;
        copy_tr.wdata_in   = this.wdata_in;
        copy_tr.strb_in    = this.strb_in;

        return copy_tr;
    endfunction

endclass

//Read
class apb_m_read_transaction extends apb_m_transaction;

    constraint read_only {
        write_read == 0;
    }

    virtual function apb_m_transaction copy();
        apb_m_read_transaction copy_tr;
        copy_tr = new();

        copy_tr.PRDATA     = this.PRDATA;
        copy_tr.PREADY     = this.PREADY;
        copy_tr.PSLVERR    = this.PSLVERR;
        copy_tr.transfer   = this.transfer;
        copy_tr.write_read = this.write_read;
        copy_tr.addr_in    = this.addr_in;
        copy_tr.wdata_in   = this.wdata_in;
        copy_tr.strb_in    = this.strb_in;

        return copy_tr;
    endfunction

endclass

//bck to bck write
class apb_m_b2b_write_transaction extends apb_m_transaction;

    constraint b2b_write {
        transfer   == 1;
        write_read == 1;
    }

    virtual function apb_m_transaction copy();
        apb_m_b2b_write_transaction copy_tr;
        copy_tr = new();

        copy_tr.PRDATA     = this.PRDATA;
        copy_tr.PREADY     = this.PREADY;
        copy_tr.PSLVERR    = this.PSLVERR;
        copy_tr.transfer   = this.transfer;
        copy_tr.write_read = this.write_read;
        copy_tr.addr_in    = this.addr_in;
        copy_tr.wdata_in   = this.wdata_in;
        copy_tr.strb_in    = this.strb_in;

        return copy_tr;
    endfunction

endclass

//bck to bck read
class apb_m_b2b_read_transaction extends apb_m_transaction;

    constraint b2b_read {
        transfer   == 1;
        write_read == 0;
    }

    virtual function apb_m_transaction copy();
        apb_m_b2b_read_transaction copy_tr;
        copy_tr = new();

        copy_tr.PRDATA     = this.PRDATA;
        copy_tr.PREADY     = this.PREADY;
        copy_tr.PSLVERR    = this.PSLVERR;
        copy_tr.transfer   = this.transfer;
        copy_tr.write_read = this.write_read;
        copy_tr.addr_in    = this.addr_in;
        copy_tr.wdata_in   = this.wdata_in;
        copy_tr.strb_in    = this.strb_in;

        return copy_tr;
    endfunction

endclass



