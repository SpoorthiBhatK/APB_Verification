`include "defines.svh"
class apb_m_op_monitor;
apb_m_transaction m_th;
mailbox #(apb_m_transaction) ms_mbx;
virtual apb_m_interface.op_MON vif;

function new(virtual apb_m_interface.op_MON vif,
	    mailbox #(apb_m_transaction) ms_mbx);
	this.vif = vif;
	this.ms_mbx = ms_mbx;
endfunction

task start();
	repeat(3)@(vif.op_monitor_cb);
	for (int i=0; i<`NT; i++) begin
		m_th = new();
		do begin
			@(vif.op_monitor_cb);
			//$display("Stuck"); 
		end
		while(!(vif.op_monitor_cb.transfer_done));
			m_th.PADDR = vif.op_monitor_cb.PADDR;
			m_th.PSEL = vif.op_monitor_cb.PSEL;
			m_th.PENABLE = vif.op_monitor_cb.PENABLE;
			m_th.PWRITE = vif.op_monitor_cb.PWRITE;
			m_th.PWDATA = vif.op_monitor_cb.PWDATA;
			m_th.PSTRB = vif.op_monitor_cb.PSTRB;
			m_th.rdata_out = vif.op_monitor_cb.rdata_out;
			m_th.transfer_done = vif.op_monitor_cb.transfer_done;
			m_th.error = vif.op_monitor_cb.error;
		$display("\n\n\n[%t]------------------------Op-Monitor passing data to scoreboard------------------NT: %d------", $time, i);
		$display("PADDR: %h, PSEL: %d, PENABLE: %d, PWRITE: %d, PWDATA: %h, PSTRB: %h, rdata_out: %h, transfer_done: %d, error: %d", m_th.PADDR, m_th.PSEL, m_th.PENABLE, m_th.PWRITE, m_th.PWDATA, m_th.PSTRB, m_th.rdata_out, m_th.transfer_done, m_th.error);
		
		ms_mbx.put(m_th);
	end
endtask
endclass
