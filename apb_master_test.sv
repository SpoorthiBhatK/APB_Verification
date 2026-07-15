`include "defines.svh"
class apb_master_test;

virtual apb_m_interface drv_vif;
virtual apb_m_interface ip_mon_vif;
virtual apb_m_interface op_mon_vif;

apb_master_environment env;

function new(virtual apb_m_interface drv_vif,
	     virtual apb_m_interface ip_mon_vif,
	     virtual apb_m_interface op_mon_vif
);
	this.drv_vif = drv_vif;
	this.ip_mon_vif = ip_mon_vif;
	this.op_mon_vif = op_mon_vif;
endfunction

task run();
	env = new(drv_vif, ip_mon_vif, op_mon_vif);
	env.build();
	env.start();
endtask
endclass

