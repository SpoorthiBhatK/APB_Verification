`include "defines.svh"
class apb_m_op_monitor;
apb_m_transaction m_th;
mailbox #(apb_m_transaction) ms_mbx;
virtual apb_m_interface.op_MON vif;
/*
covergroup mon_cg;
PADDR_cp : coverpoint m_th.PADDR
{
option.auto_bin_max = 3;
}
PSEL_cp : coverpoint m_th.PSEL
{
bins PSEL_low  = {0};
bins PSEL_high = {1};
}
PENABLE_cp : coverpoint m_th.PENABLE
{
bins PENABLE_low  = {0};
bins PENABLE_high = {1};
}
PWRITE_cp : coverpoint m_th.PWRITE
{
bins PWRITE_low  = {0};
bins PWRITE_high = {1};
}
PWDATA_cp : coverpoint m_th.PWDATA
{
option.auto_bin_max = 3;
}
PSTRB_cp : coverpoint m_th.PSTRB
{
option.auto_bin_max = 3;
}
rdata_out_cp : coverpoint m_th.rdata_out
{
option.auto_bin_max = 3;
}
transfer_done_cp : coverpoint m_th.transfer_done
{
bins td_low  = {0};
bins td_high = {1};
}
error_cp : coverpoint m_th.error
{
bins err_low  = {0};
bins err_high = {1};
}

PWRITE_PWDATA_cr : cross PWRITE_cp, PWDATA_cp
{
}
transfer_done_error_cr : cross transfer_done_cp, error_cp
{
}

PSEL_PENABLE_cr :cross PSEL_cp, PENABLE_cp
{
}
endgroup
*/
function new(virtual apb_m_interface.op_MON vif,
	    mailbox #(apb_m_transaction) ms_mbx);
	this.vif = vif;
	this.ms_mbx = ms_mbx;
	//mon_cg = new();
endfunction

task start();
	//repeat(2)@(vif.op_monitor_cb);
	for (int i=0; i<`NT; i++) begin
	repeat(1)@(vif.op_monitor_cb);
		m_th = new();
		@(vif.op_monitor_cb iff vif.op_monitor_cb.PSEL && vif.op_monitor_cb.PENABLE && vif.op_monitor_cb.PREADY);
			m_th.PADDR = vif.op_monitor_cb.PADDR;
			m_th.PSEL = vif.op_monitor_cb.PSEL;
			m_th.PENABLE = vif.op_monitor_cb.PENABLE;
			m_th.PWRITE = vif.op_monitor_cb.PWRITE;
			m_th.PWDATA = vif.op_monitor_cb.PWDATA;
			m_th.PSTRB = vif.op_monitor_cb.PSTRB;
			m_th.rdata_out = vif.op_monitor_cb.rdata_out;
			m_th.transfer_done = vif.op_monitor_cb.transfer_done;
			m_th.error = vif.op_monitor_cb.error;
			m_th.PREADY  = vif.op_monitor_cb.PREADY;
			m_th.PSLVERR = vif.op_monitor_cb.PSLVERR;
		$display("\n\n\n[%t]------------------------Op-Monitor passing data to scoreboard------------------NT: %d------", $time, i);
		$display("PADDR: %h, PSEL: %d, PENABLE: %d, PWRITE: %d, PWDATA: %h, PSTRB: %h, rdata_out: %h, transfer_done: %d, error: %d, PREADY: %d, PSLVERR: %d", m_th.PADDR, m_th.PSEL, m_th.PENABLE, m_th.PWRITE, m_th.PWDATA, m_th.PSTRB, m_th.rdata_out, m_th.transfer_done, m_th.error, m_th.PREADY, m_th.PSLVERR);
		//mon_cg.sample();
		ms_mbx.put(m_th);
		//$display("Output Functional coverage: %d", mon_cg.get_coverage());
	end
endtask
endclass
