`include "defines.svh"

interface apb_m_interface(input bit PCLK, PRESETn);
	logic [`DW-1:0]PRDATA;
	logic PREADY;
	logic PSLVERR;
	logic transfer;
	logic write_read;
	logic [`AW-1:0]addr_in;
	logic [`DW-1:0]wdata_in;
	logic [(`DW/8)-1:0]strb_in;

	logic [`AW-1:0]PADDR;
	logic PSEL;
	logic PENABLE;
	logic PWRITE;
	logic [`DW-1:0]PWDATA;
	logic [(`DW/8)-1:0]PSTRB;
	logic [`DW-1:0]rdata_out;
	logic transfer_done;
	logic error;

clocking driver_cb@(posedge PCLK);
	default input #1 output #1;
	input PRESETn,
	      PSEL,
	      PENABLE;
	output PRDATA,
	       PREADY,
	       PSLVERR,
	       transfer,
	       write_read,
	       addr_in,
               wdata_in,
	       strb_in;
endclocking

clocking op_monitor_cb@(posedge PCLK);
	default input #1 output #1;
	input PADDR,
	      PSEL,
	      PENABLE,
	      PWRITE,
              PWDATA,
	      PSTRB,
              rdata_out,
              transfer_done,
	      PREADY,
	      PSLVERR,
              error,
	      PRESETn;
endclocking

clocking inp_monitor_cb @(posedge PCLK);
    default input #1 output #1;

    input PRESETn,
          PRDATA,
          PREADY,
          PSLVERR,
          transfer,
          write_read,
          addr_in,
          wdata_in,
          strb_in;
endclocking

modport DRV(clocking driver_cb);
modport ip_MON(clocking inp_monitor_cb);
modport op_MON(clocking op_monitor_cb);

endinterface
       


