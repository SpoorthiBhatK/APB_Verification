`include "defines.svh"
class apb_m_driver;
apb_m_transaction d_th;
mailbox #(apb_m_transaction) gd_mbx;
//mailbox #(apb_m_transaction) dr_mbx;
//mailbox #(apb_m_transaction) g_ip_mbx;
virtual apb_m_interface.DRV vif;

function new(mailbox #(apb_m_transaction) gd_mbx,
//	     mailbox #(apb_m_transaction) g_ip_mbx,
	     virtual apb_m_interface.DRV vif);
	this.gd_mbx = gd_mbx;
//	this.g_ip_mbx = g_ip_mbx;
	this.vif = vif;
	//drv_cg = new();
endfunction

task start();
	repeat(3)@(vif.driver_cb);
	for(int i = 0; i < `NT; i++)begin
	repeat(1)@(vif.driver_cb);
		d_th = new();
		gd_mbx.get(d_th);
	
		fork
		begin
			vif.driver_cb.transfer <= d_th.transfer;
			vif.driver_cb.write_read <= d_th.write_read;
			vif.driver_cb.addr_in <= d_th.addr_in;
			vif.driver_cb.wdata_in <= d_th.wdata_in;
			vif.driver_cb.strb_in <= d_th.strb_in;
			if (d_th.transfer) begin
				while (!(vif.driver_cb.PSEL && vif.driver_cb.PENABLE))
				@(vif.driver_cb);
				vif.driver_cb.PRDATA <= d_th.PRDATA;
				vif.driver_cb.PREADY <= d_th.PREADY;
				vif.driver_cb.PSLVERR <= d_th.PSLVERR;
				
			
			end
		end
		begin
			while (!vif.driver_cb.PRESETn)
        			@(vif.driver_cb);
		end
		join_any
		disable fork;

		if(vif.driver_cb.PRESETn == 0)begin
			vif.driver_cb.PRDATA <= 0;
			vif.driver_cb.PREADY <= 0;
			vif.driver_cb.PSLVERR <= 0;
			@(vif.driver_cb);
			vif.driver_cb.transfer <= 0;
			vif.driver_cb.write_read <= 0;
			vif.driver_cb.addr_in <= 0;
			vif.driver_cb.wdata_in <= 0;
			vif.driver_cb.strb_in <= 0;
			//repeat(1)@(vif.driver_cb);
			$display("\n\n\n[%t]---------------Driver Reset------------NT: %d------", $time, i);
//			$display("PRDATA: %h, PREADY: %d, PSLVERR: %d, transfer: %d, write_read: %d, addr_in: %d, wdata_in: %d, strb_in: %d", vif.driver_cb.PRDATA, vif.driver_cb.PREADY, vif.driver_cb.PSLVERR, vif.driver_cb.transfer, vif.driver_cb.write_read, vif.driver_cb.addr_in, vif.driver_cb.wdata_in, vif.driver_cb.strb_in);
			$display("PRDATA: %h, PREADY: %d, PSLVERR: %d, transfer: %d, write_read: %d, addr_in: %h, wdata_in: %h, strb_in: %d", d_th.PRDATA, d_th.PREADY, d_th.PSLVERR, d_th.transfer, d_th.write_read, d_th.addr_in, d_th.wdata_in, d_th.strb_in);		
		end
		
		$display("\n\n\n[%t]---------------Driver driving data---------NT: %d------", $time, i);
		$display("PRDATA: %h, PREADY: %d, PSLVERR: %d, transfer: %d, write_read: %d, addr_in: %h, wdata_in: %h, strb_in: %d", d_th.PRDATA, d_th.PREADY, d_th.PSLVERR, d_th.transfer, d_th.write_read, d_th.addr_in, d_th.wdata_in, d_th.strb_in);
		end
	
endtask
endclass
	
