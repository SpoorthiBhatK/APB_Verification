`include "defines.svh"

class apb_m_ip_monitor;

apb_m_transaction m_th;
mailbox #(apb_m_transaction) ms_mbx;
virtual apb_m_interface.ip_MON vif;

covergroup mon_cg;
PRESETn_cp: coverpoint vif.inp_monitor_cb.PRESETn
{
bins PRESETn_low = {0};
bins PRESETn_high = {1};
}
PRDATA_cp: coverpoint m_th.PRDATA
{
option.auto_bin_max = 3;
}
PREADY_cp: coverpoint m_th.PREADY
{
bins PREADY_low = {0};
bins PREADY_high = {1};
}
PSLVERR_cp: coverpoint m_th.PSLVERR
{
bins PSLVERR_low = {0};
bins PSLVERR_high = {1};
}
transfer_cp: coverpoint m_th.transfer
{
bins transfer_low = {0};
bins transfer_high = {1};
}
write_read_cp: coverpoint m_th.write_read
{
bins write_read_low = {0};
bins write_read_high = {1};
}
addr_in_cp: coverpoint m_th.addr_in
{
option.auto_bin_max = 3;
}
wdata_in_cp: coverpoint m_th.wdata_in
{
option.auto_bin_max = 3;
}
strb_in_cp: coverpoint m_th.strb_in
{
option.auto_bin_max = 3;
}

PRESETn_transfer_cr: cross PRESETn_cp, transfer_cp
{
}

write_read_transfer_cr: cross write_read_cp, transfer_cp
{
}
transfer_addr_in_cr: cross transfer_cp, addr_in_cp
{
}
write_read_wdata_in_cr: cross write_read_cp, wdata_in_cp
{
}
transfer_strb_in_cr : cross transfer_cp, strb_in_cp
{
}
endgroup


function new(
    virtual apb_m_interface.ip_MON vif,
    mailbox #(apb_m_transaction) ms_mbx
);

    this.vif    = vif;
    this.ms_mbx = ms_mbx;

    mon_cg = new();

endfunction


task start();

    repeat(3) @(vif.inp_monitor_cb);

    for(int i=0; i<`NT; i++)
    begin
	
        do
            @(vif.inp_monitor_cb);
        while(!(vif.inp_monitor_cb.transfer));

        m_th = new();

        m_th.transfer   = vif.inp_monitor_cb.transfer;
        m_th.write_read = vif.inp_monitor_cb.write_read;
        m_th.addr_in    = vif.inp_monitor_cb.addr_in;
        m_th.strb_in    = vif.inp_monitor_cb.strb_in;

        do
            @(vif.inp_monitor_cb);
        while(!(vif.inp_monitor_cb.PREADY));

        m_th.PSLVERR  = vif.inp_monitor_cb.PSLVERR;
        m_th.PREADY   = vif.inp_monitor_cb.PREADY;
        m_th.wdata_in = vif.inp_monitor_cb.wdata_in;
        m_th.PRDATA   = vif.inp_monitor_cb.PRDATA;

        $display(
            "INPUT MONITOR PASSING THE INPUT DATA TO SCOREBOARD transfer=%0d,write_read=%0d,addr_in=%0h,wdata_in=%0h,strb_in=%0b,PSLVERR=%0d,PREADY=%0d,PRDATA=%0h",
            m_th.transfer,
            m_th.write_read,
            m_th.addr_in,
            m_th.wdata_in,
            m_th.strb_in,
            m_th.PSLVERR,
            m_th.PREADY,
            m_th.PRDATA
        );

        ms_mbx.put(m_th);

        mon_cg.sample();
    end

    $display("Input Functional Coverage = %0.2f%%", mon_cg.get_coverage());

endtask

endclass
