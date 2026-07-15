`include "apb_master.sv"
`include "packages.sv"

module apb_master_top();
import packages::*;

logic PCLK;
logic PRESETn;

initial begin
	PCLK = 0;
	forever #10 PCLK = ~PCLK;
end

initial begin
	@(posedge PCLK);
    	PRESETn = 0;
    	PRESETn = 1;
    	repeat(1) @(posedge PCLK);
    	PRESETn = 0;
    	repeat(1) @(posedge PCLK);
    	PRESETn = 1;
end

apb_m_interface intf(PCLK, PRESETn);

apb_master #(.ADDR_WIDTH(`AW), .DATA_WIDTH(`DW) )DUV(
	.PCLK(PCLK),    
	.PRESETn(PRESETn),    
	.PADDR(intf.PADDR),       
	.PSEL(intf.PSEL),      	
	.PENABLE(intf.PENABLE),    
	.PWRITE(intf.PWRITE),    
	.PWDATA(intf.PWDATA),     
	.PSTRB(intf.PSTRB),      
	.PRDATA(intf.PRDATA),     
	.PREADY(intf.PREADY),     
	.PSLVERR(intf.PSLVERR),  
	.transfer(intf.transfer),   
	.write_read(intf.write_read), 
	.addr_in(intf.addr_in),    
	.wdata_in(intf.wdata_in),   
	.strb_in(intf.strb_in),    
	.rdata_out(intf.rdata_out),  
	.transfer_done(intf.transfer_done), 
	.error(intf.error)        
);
apb_master_test t = new(intf.DRV, intf.ip_MON, intf.op_MON);
initial begin
t.run();
$finish();
end
endmodule










