`include "defines.svh"

class apb_m_generator;

apb_m_transaction g_th;
mailbox #(apb_m_transaction)gd_mbx;

function new(mailbox #(apb_m_transaction)gd_mbx);
	this.gd_mbx = gd_mbx;
	g_th = new();
endfunction

task start();
	for(int i = 0; i < `NT; i++)begin
		assert(g_th.randomize() == 1);
		gd_mbx.put(g_th.copy());
		$display("\n\n\n[%t]---------------Generator Randomized-------------------NT: %d------", $time, i);
		$display("PRDATA: %h, PREADY: %d, PSLVERR: %d, transfer: %d, write_read: %d, addr_in: %h, wdata_in: %h, strb_in: %h", g_th.PRDATA, g_th.PREADY, g_th.PSLVERR, g_th.transfer, g_th.write_read, g_th.addr_in, g_th.wdata_in, g_th.strb_in);
	end
endtask
endclass

