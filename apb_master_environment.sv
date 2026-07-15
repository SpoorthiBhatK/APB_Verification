`include "defines.svh"
class apb_master_environment;

virtual apb_m_interface.DRV drv_vif;
virtual apb_m_interface.ip_MON ip_mon_vif;
virtual apb_m_interface.op_MON op_mon_vif;
//virtual apb_interface.REF ref_vif;

mailbox #(apb_m_transaction) gd_mbx;
mailbox #(apb_m_transaction) dr_mbx;
mailbox #(apb_m_transaction) ims_mbx;
mailbox #(apb_m_transaction) oms_mbx;

apb_m_generator gen;
apb_m_driver drv;
apb_m_ip_monitor ip_monitor;
apb_m_op_monitor op_monitor;
apb_m_scoreboard scb;

function new(virtual apb_m_interface.DRV drv_vif,
	     virtual apb_m_interface.ip_MON ip_mon_vif,
	     virtual apb_m_interface.op_MON op_mon_vif
//	     virtual apb_interface.REF ref_vif
);
	this.drv_vif = drv_vif;
	this.ip_mon_vif = ip_mon_vif;
	this.op_mon_vif = op_mon_vif;
//	this.ref_vif = ref_vif;
endfunction

task build();
begin
	gd_mbx = new();
	dr_mbx = new();
	ims_mbx = new();
	oms_mbx = new();
	
	gen = new(gd_mbx);
	drv = new(gd_mbx, drv_vif);
	ip_monitor = new(ip_mon_vif, ims_mbx);
	op_monitor = new(op_mon_vif, oms_mbx);
	scb = new(ims_mbx, oms_mbx);
end
endtask

task start();
fork
	gen.start();
	drv.start();
	ip_monitor.start();
	op_monitor.start();
	scb.start();
join
	scb.compare_report();
endtask
endclass



